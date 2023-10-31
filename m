Return-Path: <kvm+bounces-198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 815EB7DCECF
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:11:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DA992B20F80
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 14:11:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A031DDFF;
	Tue, 31 Oct 2023 14:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eD6TW17F"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358101DFC2
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 14:10:54 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB3811F
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1698761451;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+29grXFJZojFwHG1sZMUj8N4tYbCAXJFoBUSIxQKeyY=;
	b=eD6TW17FcLteN7LBHLH1xMpKnoD53DS/htYT0H9fVG8P4rMsDrM3KmW73UhD8KT5ZEDPSG
	TngtDt4u11xuTtXdrFcJWm5+RJSLi1R2y6v/pJYCtSTJEk3deIS2k20ue4HdN6I5+iu2r1
	RVOUpE+UdZCgh+MEmmr29m+FRVoo+kA=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-cWS2x355OtiobkhUwNDK2g-1; Tue, 31 Oct 2023 10:10:49 -0400
X-MC-Unique: cWS2x355OtiobkhUwNDK2g-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6ce26047c6eso7823162a34.2
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 07:10:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698761449; x=1699366249;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+29grXFJZojFwHG1sZMUj8N4tYbCAXJFoBUSIxQKeyY=;
        b=HLVQH0dElJNWGGGuGO1J/4vpiSNHRQe6CnrQQSpUqmZes9XoJb44ug/zYSGy1B106S
         vMObFQj7hHrUZWFwGYL1k5LRuhEqg9a2/dBCpYuOVgIEj8b3qjcwzLu+COTwy7CNrtvR
         ZQBJrKCIfkBR1nXH76hbkLGtmsZ4t7LlQznRh9TgUvgCtgNBVWQU9FF6+vIqLa7P1wT8
         AHcPpxKzwcv+44o3h6aN1IpSGhAyQINi5YNEYJcnKWueyP/qABvS64QPHBEOQX8mEQpJ
         fxtQClDofm3NqApwUpV+aVzkE0Cf504nLNY6273AncqT6eWU+C9HWVeJMoKx4QoiI0wp
         4pfA==
X-Gm-Message-State: AOJu0YwLxR6JCGdvHxo1t+o7JDzHi78ha6DLb/mVo9ZhhtU/kAEw9vXb
	uOYKIR1XZP/oYaOkTOC9IkJ083kU9vnp2eOOPGSqPR2zH0b3B4MWHSgRhDolMu5H/CKGR5Z+Hnf
	zr1+sTnkxmYrp28eOctfF5MMNzSZT
X-Received: by 2002:a05:6871:23c7:b0:1e9:edd1:2176 with SMTP id xy7-20020a05687123c700b001e9edd12176mr12825503oab.33.1698761449246;
        Tue, 31 Oct 2023 07:10:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFkDNkghapOOyIO7MlIs094HOLFT5jnQNcb86xPe9HYK72gpMCPOxpT4qdgb2CzpsWn5KZbftCAGayTULfQu1w=
X-Received: by 2002:a05:6871:23c7:b0:1e9:edd1:2176 with SMTP id
 xy7-20020a05687123c700b001e9edd12176mr12825480oab.33.1698761448978; Tue, 31
 Oct 2023 07:10:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231030092101.66014-1-frankja@linux.ibm.com>
In-Reply-To: <20231030092101.66014-1-frankja@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 31 Oct 2023 15:10:37 +0100
Message-ID: <CABgObfZtmcbdtWRFmhEuZuKBMf-AgNG_25g9GHZ0o3ZPnthtZA@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] KVM: s390: Changes for 6.7
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com, 
	cohuck@redhat.com, linux-s390@vger.kernel.org, nrb@linux.ibm.com, 
	imbrenda@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 30, 2023 at 10:22=E2=80=AFAM Janosch Frank <frankja@linux.ibm.c=
om> wrote:
>
> Paolo, please pull these two patches for 6.7.
>
> They introduce counters and a tracepoint into our nested VM page table
> management code. Debuging nested page table management is notoriously
> hard but the added low-overhead debug data will allow us to get a feel
> for the problem before deploying deeper and higher overhead debugging
> means.
>
> I've held back the patches for a bit since we had suspicious CI fails
> but they turned out to be unrelated and have been fixed at the end of
> last week.

Pulled, thanks.

Paolo

>
>
> The following changes since commit ce9ecca0238b140b88f43859b211c9fdfd8e5b=
70:
>
>   Linux 6.6-rc2 (2023-09-17 14:40:24 -0700)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-next-6.7-1
>
> for you to fetch changes up to 70fea30195168fd84e7076720c984f0ac1af5b09:
>
>   KVM: s390: add tracepoint in gmap notifier (2023-10-16 14:54:29 +0200)
>
> Nico Boehr (2):
>   KVM: s390: add stat counter for shadow gmap events
>   KVM: s390: add tracepoint in gmap notifier
>
>  arch/s390/include/asm/kvm_host.h |  7 +++++++
>  arch/s390/kvm/gaccess.c          |  7 +++++++
>  arch/s390/kvm/kvm-s390.c         | 11 ++++++++++-
>  arch/s390/kvm/trace-s390.h       | 23 +++++++++++++++++++++++
>  arch/s390/kvm/vsie.c             |  5 ++++-
>  5 files changed, 51 insertions(+), 2 deletions(-)
>
> --
> 2.41.0
>


