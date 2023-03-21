Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605F96C354C
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjCUPPF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbjCUPO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:14:59 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 351204FF01
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:14:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 951D120188;
        Tue, 21 Mar 2023 15:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679411691; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FIgJYxvGxFr9oKy3IZISEqejtPHhsrO/OfDKHlx1zYw=;
        b=eGezmgSSZbDwGyTIqUTh9J+TcmwUFJ0YIGvkKGiYOaM7XgC6/20fABecqZRnEkmWgwia2q
        ti7p459UDtOzpt/amWPDRwgz/mhBZ4WkVMWdsxIbQTDLk0A3NF12DhChxTb5ZKQvHBs/wX
        VTqEclxq6dwl6audVxPpLgpYgyk+Ssw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679411691;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FIgJYxvGxFr9oKy3IZISEqejtPHhsrO/OfDKHlx1zYw=;
        b=z9h1li26KLY+otIJT9le2Bt72hjgfAMonibVKUKxsnHG87zpYy3mEhWX0N5jAHoiITb0+Z
        mK82Y5qr7efSt6Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6C95D13440;
        Tue, 21 Mar 2023 15:14:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WxcTGevJGWQ9UQAAMHmgww
        (envelope-from <jroedel@suse.de>); Tue, 21 Mar 2023 15:14:51 +0000
Date:   Tue, 21 Mar 2023 16:14:49 +0100
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZBnJ6ZCuQJTVMM8h@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
 <66eee693371c11bbd2173ad5d91afc740aa17b46.camel@linux.ibm.com>
 <ZBmmjlNdBwVju6ib@suse.de>
 <c2e8af835723c453adaba4b66db533a158076bbf.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2e8af835723c453adaba4b66db533a158076bbf.camel@linux.ibm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 09:43:48AM -0400, James Bottomley wrote:
> Could you describe these incompatible goals and explain why you think
> they are incompatible (as in why you and AMD don't think you can agree
> on it)?  That would help the rest of us understand where the two SVSM
> implementations fit in our ongoing plans.

The goal of COCONUT is to have an SVSM which has isolation capabilities
within itself. It already has percpu page-tables and in the end it will
be able to run services (like the TPM) as separate processes in ring 3
using cooperative multitasking.

With the current linux-svsm code-base this is difficult to achieve due
to its reliance on the x86-64 crate. For supporting a user-space like
execution mode the crate has too many limitations, mainly in its
page-table and IDT implementations.

The IDT code from that crate, which is also used in linux-svsm, relies
on compiler-generated entry-code. This is not enough to support a
ring-3 execution mode with syscalls and several (possibly nested) IST
vectors. The next problem with the IDT code is that it doesn't allow
modification of return register state.  This makes it impossible to
implement exception fixups to guard RMPADJUST instructions and VMPL1
memory accesses in general.

When we looked at the crate, the page-table implementation supported
basically a direct and an offset mapping, which will get us into
problems when support for non-contiguous mappings or sharing parts of a
page-table with another page-table is needed. So in the very beginning
of the project I decided to go with my own page-table implementation.

Of course we could start changing linux-svsm to support the same goals,
but I think the end result will not be very different from what COCONUT
looks now.

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Frankenstraße 146
90461 Nürnberg
Germany

(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman

