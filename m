Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217CE434B33
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 14:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhJTMea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 08:34:30 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:43364 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhJTMe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 08:34:29 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 481CA21A99;
        Wed, 20 Oct 2021 12:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634733133; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZB3eWPjo6/a4VBVAOSQrGwoLYIJMO/c6ggvnkEuPMEE=;
        b=spRlPQAEp/8bnE8P7CsHTxc1rDOtQ3QmN+dMrz3xMru+kfmsboV2CFrIoaOvGrMyWQ5m3H
        jbYrf4hioT0C7/n85xtAHrpI5Qz9JqaghRkcOVbSgHkA0mtTN6NTOI2hJIzeobEPL6ONwW
        0CC+gf+eiwmC+6QfO3zkt3YuUxxCftA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634733133;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZB3eWPjo6/a4VBVAOSQrGwoLYIJMO/c6ggvnkEuPMEE=;
        b=YUdAwqz+w0qkhHsgIqud1T/kS5BMZxUm5UgZ+L6MPYrd17RuApY9NPRLExRlKUX5dnGhYY
        S/yWt3w8I8TL5fDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D911B13AC7;
        Wed, 20 Oct 2021 12:32:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eawbM0wMcGE2XwAAMHmgww
        (envelope-from <jroedel@suse.de>); Wed, 20 Oct 2021 12:32:12 +0000
Date:   Wed, 20 Oct 2021 14:32:11 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/5] KVM: SVM: Add support to handle AP reset MSR
 protocol
Message-ID: <YXAMSyr3uByu4byY@suse.de>
References: <20210929155330.5597-1-joro@8bytes.org>
 <20210929155330.5597-4-joro@8bytes.org>
 <YWdX1WXE3AOPFC6d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWdX1WXE3AOPFC6d@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 13, 2021 at 10:04:05PM +0000, Sean Christopherson wrote:
> Rather than put more stuff into x86 that really belongs to SEV, what about moving
> kvm_emulate_ap_reset_hold() into sev.c and instead exporting __kvm_vcpu_halt()?

Did that in a separate patch and fixed things up. Also replaced the kvm_
with and sev_ prefix and the function now takes an vcpu_svm parameter.

New version coming soon.

Thanks,

	Joerg
