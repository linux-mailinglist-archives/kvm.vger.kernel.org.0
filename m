Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51E46C398D
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 19:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjCUSum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 14:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbjCUSuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 14:50:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165D14FA90
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 11:50:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5E65D203A3;
        Tue, 21 Mar 2023 18:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679424615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gx1zHnKibOB/qZ9NAYIrNX0wXPKwNQLXbcqGgVodubY=;
        b=wVMwl9f6HH1Qr390iRu0UQb/fmpPtmUyyZFbevnA4xU5Bkp1PkOIU3MI3ljAfnf3POoQu4
        VSEJENV8WtWOzAAGdhXHgi6M+fU1HCu4+Y7M/SyGQZvGqCC8m3nLVvVIFH7weLWew46HUT
        f0naiIhUXlKNpm4Sl9SvHxHZRcZCEII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679424615;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gx1zHnKibOB/qZ9NAYIrNX0wXPKwNQLXbcqGgVodubY=;
        b=fhWRTiBacCKcF5/fErC+XC8UQ5GmR91L8YsUhcdwKT9pw5tUykNFHqwaRRXIWC51Y9otKg
        nvauJWm1dtSohGCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2C3E813451;
        Tue, 21 Mar 2023 18:50:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZhVQCWf8GWSeTAAAMHmgww
        (envelope-from <jroedel@suse.de>); Tue, 21 Mar 2023 18:50:15 +0000
Date:   Tue, 21 Mar 2023 19:50:13 +0100
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     James Bottomley <jejb@linux.ibm.com>, amd-sev-snp@lists.suse.com,
        linux-coco@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZBn8ZdEBbvPMXJt2@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
 <66eee693371c11bbd2173ad5d91afc740aa17b46.camel@linux.ibm.com>
 <ZBmmjlNdBwVju6ib@suse.de>
 <c2e8af835723c453adaba4b66db533a158076bbf.camel@linux.ibm.com>
 <ZBnJ6ZCuQJTVMM8h@suse.de>
 <ZBnt9pbSfp/v1bWO@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBnt9pbSfp/v1bWO@work-vm>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 05:48:38PM +0000, Dr. David Alan Gilbert wrote:
> I'm curious why you're doing isolation using ring-3 stuff rather than
> another VMPL level?

Two reasons:

1) CPL switch is much cheaper than VMPL switch

2) CPLs allow to isolate different services within the same VMPL. Having
   services run at, say, VMPL1 on CPL-0 will allow all services on VMPL1
   to access each others memory.

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

