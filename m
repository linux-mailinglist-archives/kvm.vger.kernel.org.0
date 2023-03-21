Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695D46C39BD
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 20:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjCUTDi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 15:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjCUTDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 15:03:37 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFC053711
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 12:03:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id AB4FF203C2;
        Tue, 21 Mar 2023 19:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679425382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hgIVZ11Me5HYd9wsF00YR/laN9U31kFl1q8us/6vLUc=;
        b=Q+c5LZHA4HjOnmSML1liXv11u0Z8iGTmtwcvWmUuUPzKt+Vov1wO8CdSgSa0Jn9Z1YkXQM
        iLpSYITPMuTHqjJre9ALEtQYc41ZpxlViPrv2VV2pFoAT3reTSNnDJbYe9N2zs1zTru1dy
        bF00xgdX0bn8BTxAuudgjD0bZAsc5dY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679425382;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hgIVZ11Me5HYd9wsF00YR/laN9U31kFl1q8us/6vLUc=;
        b=YmUc/OMzJoHaHTwXiSitdPU+N1MnnBP8tBUdpxweHgEl7+t0qMHkVqJIu0edHl6PHCfEiq
        nIu91Fg2ozUINEAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 852B413451;
        Tue, 21 Mar 2023 19:03:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LeUvH2b/GWTsUgAAMHmgww
        (envelope-from <jroedel@suse.de>); Tue, 21 Mar 2023 19:03:02 +0000
Date:   Tue, 21 Mar 2023 20:03:01 +0100
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZBn/ZbFwT9emf5zw@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
 <ZBnH600JIw1saZZ7@work-vm>
 <ZBnMZsWMJMkxOelX@suse.de>
 <ZBnhtEsMhuvwfY75@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBnhtEsMhuvwfY75@work-vm>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 04:56:20PM +0000, Dr. David Alan Gilbert wrote:
> OK, I'm just trying to avoid having guests that have a zillion different
> TPM setups for different SVSM and clouds.

My guess it that it will either be the SVSM TPM protocol or an emulation
of an existing TPM interface.

> Timing is a little tricky here; in many ways the thing that sounds
> nicest to me about Coconut is the mostly-unmodified guest (b) - but if
> that's a while out then hmm.

Yeah, would be nice. But we are still in the early stages of SVSM
development, so the priority now is to get services up and running.

But the project is open source and anyone can start looking into the
unmodified guest handling and send PRs. Making this happen is certainly
a multi-step process, as it requires several things to be implemented.
Just out of my head an incomplete list what is required:

	1) ReflectVC handling with instruction decoder and guest TLB
	   flush awareness
	2) vTOM handling
	3) Interrupt proxying using alternate injection (that can make
	   sense even earlier and without the other features imho)

So its quite some work, but if someone wants to look into that now I am
all for it.

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

