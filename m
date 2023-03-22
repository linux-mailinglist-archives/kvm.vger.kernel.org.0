Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACC86C4611
	for <lists+kvm@lfdr.de>; Wed, 22 Mar 2023 10:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCVJTZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Mar 2023 05:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjCVJTX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Mar 2023 05:19:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B7C1556B
        for <kvm@vger.kernel.org>; Wed, 22 Mar 2023 02:19:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id EDD9A33935;
        Wed, 22 Mar 2023 09:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679476759; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86WAXgr037FRvrv00CobmumLZdMEQGnDLNi0ZNwoT4E=;
        b=fuwE7AabSbu2e2JS2kLEdedDo78y7FCrAp141UihCtbFEu6APGDjh0MKD+PK0sM1UjFCmL
        mwr4l7dGbNDSsCBVPyPRHF75bB/AScZeVrUeA4OGJAP3FmgxMZUsdMagCvls+8QiIrFqOE
        oCyXVpa+kvocJjYvppJWSwY4+ICWwXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679476759;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86WAXgr037FRvrv00CobmumLZdMEQGnDLNi0ZNwoT4E=;
        b=NWkh/EVOIAQtd4HzmdT6V2Pv0Jf4Fxd9fPKIzXBbmOCNlMtLxrnm7rDl158IffgfujHN3g
        /izUXeae4fYL5jCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C594C13416;
        Wed, 22 Mar 2023 09:19:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xAm6LhfIGmSIYAAAMHmgww
        (envelope-from <jroedel@suse.de>); Wed, 22 Mar 2023 09:19:19 +0000
Date:   Wed, 22 Mar 2023 10:19:18 +0100
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZBrIFnlPeCsP0x2g@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
 <ZBnH600JIw1saZZ7@work-vm>
 <ZBnMZsWMJMkxOelX@suse.de>
 <ZBnhtEsMhuvwfY75@work-vm>
 <ZBn/ZbFwT9emf5zw@suse.de>
 <ZBoLVktt77F9paNV@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBoLVktt77F9paNV@work-vm>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 21, 2023 at 07:53:58PM +0000, Dr. David Alan Gilbert wrote:
> OK; the other thing that needs to get nailed down for the vTPM's is the
> relationship between the vTPM attestation and the SEV attestation.
> i.e. how to prove that the vTPM you're dealing with is from an SNP host.
> (Azure have a hack of putting an SNP attestation report into the vTPM
> NVRAM; see
> https://github.com/Azure/confidential-computing-cvm-guest-attestation/blob/main/cvm-guest-attestation.md
> )

When using the SVSM TPM protocol it should be proven already that the
vTPM is part of the SNP trusted base, no? The TPM communication is
implicitly encrypted by the VMs memory key and the SEV attestation
report proves that the correct vTPM is executing.

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

