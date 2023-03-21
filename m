Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F706C31FD
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 13:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjCUMqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 08:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjCUMp6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 08:45:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C27C39CDA
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 05:45:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7D8582000D;
        Tue, 21 Mar 2023 12:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679402640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L+7qSU8PTZ7jb1QFaGzVCG7WQ11iWdZECtfo29qI5vI=;
        b=dXudV0HgmOUDu0xMnbKEAgdDSpOJniYolzdcHftM2zWGzoSnrI2UiM8mL7EPcEOa9FT3b7
        O8rg1AbUJ7AdpmngqScZvj9CCtywT+8XiZLFIgxpUwLyLdw6+ciDv8G6m2rRAyVz1WbmMZ
        7IsMQ8mmTEK++BmKuyUI8HfGo4KdLmM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679402640;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L+7qSU8PTZ7jb1QFaGzVCG7WQ11iWdZECtfo29qI5vI=;
        b=tMhnkDDf8+E2ELrKJQwRowhJRRwOTCyQ3hXVGXpOldVY6gCE+/0Cz/RwpCn+v8tefuMlq5
        74hocgPcTbtAYpBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 532F513440;
        Tue, 21 Mar 2023 12:44:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dDzeEpCmGWQeYgAAMHmgww
        (envelope-from <jroedel@suse.de>); Tue, 21 Mar 2023 12:44:00 +0000
Date:   Tue, 21 Mar 2023 13:43:58 +0100
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
To:     James Bottomley <jejb@linux.ibm.com>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZBmmjlNdBwVju6ib@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
 <66eee693371c11bbd2173ad5d91afc740aa17b46.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <66eee693371c11bbd2173ad5d91afc740aa17b46.camel@linux.ibm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi James,

On Tue, Mar 21, 2023 at 07:09:40AM -0400, James Bottomley wrote:
> Since this a fork of the AMD svsm code
> (https://github.com/AMDESE/linux-svsm/), is it intended to be a
> permanent fork, or are you going to be submitting your additions back
> upstream like we're trying to do for our initial vTPM prototype?  From
> the community point of view, having two different SVSM code bases and
> having to choose which one to develop against is going to be very
> confusing ...

The COCONUT-SVSM was and is a separate project and not a fork of AMDs
linux-svsm. Some code was ported from our code-base to linux-svsm in the
past, namely the SpinLock implementation and the memory allocators.

What the project also shares with linux-svsm is the support code in the
Linux kernel (host and guest) and the EDK2 changes needed to launch an
SVSM.

But besides that the two code-bases are different, using a different
build approach and different launch protocol. The goals we have with our
SVSM are hard to achieve with the linux-svsm code-base, so a merge does
not make sense at this point.

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

