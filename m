Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542F36F85E2
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 17:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbjEEPe0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 11:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbjEEPeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 11:34:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CB811A
        for <kvm@vger.kernel.org>; Fri,  5 May 2023 08:34:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0E99F22874;
        Fri,  5 May 2023 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683300862; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=amgb/S45FvJcm5JMcL1KEBjpNVbGpOR+FYQgsdablTM=;
        b=Vi4Jh1NAnwil3SZTzfCuv01DlU2Sft7MMDCFeNeKQntflE/JoOjWE5UBsPimzTZZ5DYHod
        nR47hPLkPId1V5Ntr/A9HvQuwIZHr2MwL6mghnUe2ynTQZMzdNkHNhaRgt+9V317X8p7kj
        hSM+9yX6tbL8ljZExA737veIY3pjhGY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683300862;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=amgb/S45FvJcm5JMcL1KEBjpNVbGpOR+FYQgsdablTM=;
        b=4mLoQ1+UkJJfwzR7TBe2GY8fU5plF9Q3dtscZbuRWivSlV4lqF6QR8sXojqxIwRW5qeNuf
        5K2S2wxNu0uAc7Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CADD113488;
        Fri,  5 May 2023 15:34:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HZ0kMP0hVWRqEwAAMHmgww
        (envelope-from <jroedel@suse.de>); Fri, 05 May 2023 15:34:21 +0000
Date:   Fri, 5 May 2023 17:34:20 +0200
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
To:     Claudio Carvalho <cclaudio@linux.ibm.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, amd-sev-snp@lists.suse.com,
        linux-coco@lists.linux.dev, kvm@vger.kernel.org,
        Carlos Bilbao <carlos.bilbao@amd.com>,
        Klaus Kiwi <kkiwi@redhat.com>
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZFUh/KlLXJF+2hoJ@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
 <4420d7e5-d05f-8c31-a0f2-587ebb7eaa20@amd.com>
 <ZFJTDtMK0QqXK5+E@suse.de>
 <cc22183359d107dc0be58b4f9509c8d785313879.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc22183359d107dc0be58b4f9509c8d785313879.camel@linux.ibm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Claudio,

On Wed, May 03, 2023 at 12:51:17PM -0400, Claudio Carvalho wrote:
> Thanks. I would be happy to collaborate in that discussion.

Great, I will send out that email early next week to get the discussion
rolling.

> I think the crypto support requires more design discussion since it is required
> in multiple places.
> 
> The experience I've had adding SVSM-vTPM support is that the SVSM needs crypto
> for requesting an attestation report (SNP_GUEST_REQUEST messages sent to the
> security processor PSP have to be encrypted with AES_GCM) and the vTPM also
> needs crypto for the TPM crypto operations. We could just duplicate the crypto
> library, or find a way to share it (e.g. vdso approach).
> 
> For the SVSM, it would be rust code talking to the crypto library; for the vTPM
> it would be the vTPM (most likely an existing C implementation) talking to the
> crypto library.

Right, where to place and how to share the crypto code needs more
discussion, there are multiple possible approaches. I have seen that you
have a talk at KVM Forum, so we can meet there in a larger group and
discuss those and other questions in person.

I think from this thread and other discussions happening it became clear
that there are currently a lot of different opinions on what the SVSM
should do and how it should look like. It would be great if we as a
community can get closer together on those questions (which is certainly
helpful for combining efforts).

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

