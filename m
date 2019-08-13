Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3CDD8B8AB
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 14:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbfHMMh1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 08:37:27 -0400
Received: from fanzine.igalia.com ([91.117.99.155]:48632 "EHLO
        fanzine.igalia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727763AbfHMMh1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 08:37:27 -0400
X-Greylist: delayed 1055 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Aug 2019 08:37:25 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com; s=20170329;
        h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:Subject:Cc:To:From; bh=Pp7j3ake9Twj27K/AYPjk4E1mNmMMWRUgGjTMmlIq9o=;
        b=if1CQNI+nayvDOCo9zrpAusZkBfmUDziNxGj9ortFu/uScSOAYfdSCJpdfOqWaJqlvtq4A0PXIE2yuiIZOGsWvwaS1PJakNf5/BpyL6ATpMpGSH42Loni2fWdbuM8R9X/os0Qt+uwQQM7R+CZDCUHNO0D1Jrirl80QQNmS1KiAygarRUm5BklQ7s+PS/++nc9jJUV/u43W9ndueE35U3FmP44VOiRGNw+LdA4dcM44o+nx9/uisi8lq7C7zfgCRHx5j7/gi3poDDka3Pn3qubVDrpEBzC8eaG/duO1jksNJHN8iYzVLyFes+bLuPZG3jGTDt9IFQ+s1NnOEHax/xxQ==;
Received: from maestria.local.igalia.com ([192.168.10.14] helo=mail.igalia.com)
        by fanzine.igalia.com with esmtps 
        (Cipher TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim)
        id 1hxVmD-0008Ot-8T; Tue, 13 Aug 2019 14:19:45 +0200
Received: from berto by mail.igalia.com with local (Exim)
        id 1hxVmD-0004Jl-5V; Tue, 13 Aug 2019 14:19:45 +0200
From:   Alberto Garcia <berto@igalia.com>
To:     Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>,
        qemu-devel@nongnu.org, qemu-block@nongnu.org
Cc:     kvm@vger.kernel.org, mdroth@linux.vnet.ibm.com, armbru@redhat.com,
        ehabkost@redhat.com, rth@twiddle.net, mtosatti@redhat.com,
        pbonzini@redhat.com, den@openvz.org, vsementsov@virtuozzo.com,
        andrey.shinkevich@virtuozzo.com
Subject: Re: [PATCH 1/3] test-throttle: Fix uninitialized use of burst_length
In-Reply-To: <1564502498-805893-2-git-send-email-andrey.shinkevich@virtuozzo.com>
References: <1564502498-805893-1-git-send-email-andrey.shinkevich@virtuozzo.com> <1564502498-805893-2-git-send-email-andrey.shinkevich@virtuozzo.com>
User-Agent: Notmuch/0.18.2 (http://notmuchmail.org) Emacs/24.4.1 (i586-pc-linux-gnu)
Date:   Tue, 13 Aug 2019 14:19:45 +0200
Message-ID: <w51a7cddzq6.fsf@maestria.local.igalia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue 30 Jul 2019 06:01:36 PM CEST, Andrey Shinkevich wrote:
> ThrottleState::cfg of the static variable 'ts' is reassigned with the
> local one in the do_test_accounting() and then is passed to the
> throttle_account() with uninitialized member LeakyBucket::burst_length.
>
> Signed-off-by: Andrey Shinkevich <andrey.shinkevich@virtuozzo.com>

Reviewed-by: Alberto Garcia <berto@igalia.com>

Berto
