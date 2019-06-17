Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF6CA48E4B
	for <lists+kvm@lfdr.de>; Mon, 17 Jun 2019 21:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfFQTXZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jun 2019 15:23:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53175 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725497AbfFQTXY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jun 2019 15:23:24 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 490ECC07410F;
        Mon, 17 Jun 2019 19:23:24 +0000 (UTC)
Received: from flask (unknown [10.43.2.199])
        by smtp.corp.redhat.com (Postfix) with SMTP id 6AE1A783BB;
        Mon, 17 Jun 2019 19:23:19 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Mon, 17 Jun 2019 21:23:18 +0200
Date:   Mon, 17 Jun 2019 21:23:18 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: clean up conditions for asynchronous page
 fault handling
Message-ID: <20190617192318.GA13948@flask>
References: <1560446532-22494-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1560446532-22494-1-git-send-email-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 17 Jun 2019 19:23:24 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-06-13 19:22+0200, Paolo Bonzini:
> Even when asynchronous page fault is disabled, KVM does not want to pause
> the host if a guest triggers a page fault; instead it will put it into
> an artificial HLT state that allows running other host processes while
> allowing interrupt delivery into the guest.
> 
> However, the way this feature is triggered is a bit confusing.
> First, it is not used for page faults while a nested guest is
> running: but this is not an issue since the artificial halt
> is completely invisible to the guest, either L1 or L2.  Second,
> it is used even if kvm_halt_in_guest() returns true; in this case,
> the guest probably should not pay the additional latency cost of the
> artificial halt, and thus we should handle the page fault in a
> completely synchronous way.
> 
> By introducing a new function kvm_can_deliver_async_pf, this patch
> commonizes the code that chooses whether to deliver an async page fault
> (kvm_arch_async_page_not_present) and the code that chooses whether a
> page fault should be handled synchronously (kvm_can_do_async_pf).
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---

Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
