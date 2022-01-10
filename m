Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC948A2BA
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 23:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345417AbiAJW3S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 17:29:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46979 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1345394AbiAJW3R (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 Jan 2022 17:29:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641853757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w9kH2tIhMPMlxhb7Lqs2IM+KkKwFlqOjjZ1oRqKPLcw=;
        b=CcC5KymOpAeG4PmGqlQX23dWJ0t2dwfCjI8JbIzKyEO06ylUNPHUaieKmq0g3X5/9zCAt6
        P3sDzaR7sIfIHipMucTMcuDd/Xq+ebTsLz2q1Z8GUYJalUJeSnWHqldiGHuyPDEI4b/PCK
        5U0qEn99eqPot3UiZth1iuWXvq0BrCw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-ihCd9uK8NJCkU0vH0kvGkA-1; Mon, 10 Jan 2022 17:29:15 -0500
X-MC-Unique: ihCd9uK8NJCkU0vH0kvGkA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4B3F835E2B;
        Mon, 10 Jan 2022 22:29:14 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4CC87B015;
        Mon, 10 Jan 2022 22:29:13 +0000 (UTC)
Message-ID: <f9581f0f8ce8fa465b1124cb803afaa7ef80d7bd.camel@redhat.com>
Subject: Re: [Bug 215459] VM freezes starting with kernel 5.15
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     bugzilla-daemon@bugzilla.kernel.org, kvm@vger.kernel.org
Date:   Tue, 11 Jan 2022 00:29:12 +0200
In-Reply-To: <bug-215459-28872-yRHoQoMyNS@https.bugzilla.kernel.org/>
References: <bug-215459-28872@https.bugzilla.kernel.org/>
         <bug-215459-28872-yRHoQoMyNS@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-01-10 at 09:30 +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=215459
> 
> --- Comment #9 from th3voic3@mailbox.org ---
> I've compiled the 5.16 kernel now and so far it's looking very good. APICv and
> tdp_mmu are both enabled. Also thanks to dynamic PREEMPT I no longer need to
> recompile to enable voluntary preemption to cut down my VMs boot time.
> 
Great to hear that.
 
I am just curious, with what PREEMPT setting, the boot is slow?
With full preemption? I also noticed that long ago, before I joined redhat,
back when I was just a VFIO fan, that booting with large amounts of ram
(32 back then I think), forced preemption and passed-through GPU makes
The VM hang for about like 1/2 of a minute before it shows the bios splash screen.
 
Best regards,
	Maxim Levitsky


