Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E211FAF61
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 13:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgFPLiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 07:38:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58540 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726306AbgFPLiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Jun 2020 07:38:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592307480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=/+Khb+NkKuL4NG8HX4t32uwSAq5CQnaOLAry7tGmUfQ=;
        b=TqenBQwHVtpEd7Wczq3y8doSOPVFlaEevCcXStwpOg65Iff4lmRxFRyuTqGib4gPyxVh28
        zCyoagybWqdpC0ZLvsc3oAJ0lzd6boYn2K4VENM48nMp7S4YoVEgZmrRbKrDQKMjdmssWG
        qqvfkCGorMhHpwifSRMOk6rQ66K9rcQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-2jpOv92SMuOLTGb5Tm9plw-1; Tue, 16 Jun 2020 07:37:55 -0400
X-MC-Unique: 2jpOv92SMuOLTGb5Tm9plw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91C8780333B;
        Tue, 16 Jun 2020 11:37:54 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-128.ams2.redhat.com [10.36.114.128])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B0DA7930E;
        Tue, 16 Jun 2020 11:37:49 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v9 10/12] s390x: css: stsch, enumeration
 test
To:     Pierre Morel <pmorel@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com
References: <1592213521-19390-1-git-send-email-pmorel@linux.ibm.com>
 <1592213521-19390-11-git-send-email-pmorel@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <4a366110-51cd-4473-3b93-3e92d7800c3f@redhat.com>
Date:   Tue, 16 Jun 2020 13:37:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1592213521-19390-11-git-send-email-pmorel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/06/2020 11.31, Pierre Morel wrote:
> First step for testing the channel subsystem is to enumerate the css and
> retrieve the css devices.
> 
> This tests the success of STSCH I/O instruction, we do not test the
> reaction of the VM for an instruction with wrong parameters.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/css_lib.c | 70 +++++++++++++++++++++++++++++++++++++++++++++
>  s390x/Makefile      |  2 ++
>  s390x/css.c         | 55 +++++++++++++++++++++++++++++++++++
>  s390x/unittests.cfg |  4 +++
>  4 files changed, 131 insertions(+)
>  create mode 100644 lib/s390x/css_lib.c
>  create mode 100644 s390x/css.c

Acked-by: Thomas Huth <thuth@redhat.com>

