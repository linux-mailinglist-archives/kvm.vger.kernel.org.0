Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8A014BF56
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 19:14:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgA1SN7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 13:13:59 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37826 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726820AbgA1SN7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jan 2020 13:13:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580235238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eaBBOCn6OURZSUPK3u2w/eaYI82kORBB3oPhikkORns=;
        b=NoJpyb1cLmO3uycxnE4VYnVF4+zHbhZqEEM7Qo3rTXLZCrzMYBzh0jbrNR6xExILO+ibdz
        X/i97sex7mKC8ZjmQMsJr+nB4JIY6ir/fj1QdCN6y9Tw/WojW8jsFfipB7oAekn3oAVUCU
        ndjCqUXmp8PALLg84HdA4HcnPs2bh1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-2JCGO721PaaedOruK2O4ew-1; Tue, 28 Jan 2020 13:13:54 -0500
X-MC-Unique: 2JCGO721PaaedOruK2O4ew-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DDD08010C9;
        Tue, 28 Jan 2020 18:13:53 +0000 (UTC)
Received: from gondolin (ovpn-116-186.ams2.redhat.com [10.36.116.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E8605C1D8;
        Tue, 28 Jan 2020 18:13:51 +0000 (UTC)
Date:   Tue, 28 Jan 2020 19:13:48 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 11/27] docs: kvm: convert devices/s390_flic.txt to ReST
Message-ID: <20200128191348.497334df.cohuck@redhat.com>
In-Reply-To: <12634be89f4a8b662bf4bc0a0c7baef42675548f.1580219586.git.mchehab+huawei@kernel.org>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
        <12634be89f4a8b662bf4bc0a0c7baef42675548f.1580219586.git.mchehab+huawei@kernel.org>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 28 Jan 2020 15:00:12 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> - Use standard markup for document title;
> - Adjust indentation and add blank lines as needed;
> - use the notes markup;
> - mark code blocks as such.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  Documentation/virt/kvm/devices/index.rst      |  1 +
>  .../devices/{s390_flic.txt => s390_flic.rst}  | 68 +++++++++++--------
>  2 files changed, 39 insertions(+), 30 deletions(-)
>  rename Documentation/virt/kvm/devices/{s390_flic.txt => s390_flic.rst} (88%)

Duplicate... old files?

