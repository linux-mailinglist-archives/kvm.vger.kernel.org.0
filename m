Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C1E6C3592
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjCUPZc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjCUPZa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:25:30 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C004A1D0
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:25:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 54F5A201A8;
        Tue, 21 Mar 2023 15:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679412328; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rn4O4CShsZUobHxhdMV/dIUP3ZK0/XXmESfdmwn94Bw=;
        b=hWuDgKu4d60NVjpkMWkCL2la1R5GShHK7G+Br4e0OBFjEUAEzzEtMBWdtmFpcibFoMTj2E
        rXZg1NKxOJbeYvQy0pOpLc4mqN8SAduSFuJyTIRe6c/WgQsitRA6up8pAdzZgDPW6IS8iU
        jT/DIeAfONYygzlfuG3KwZZpLuHPQ9Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679412328;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rn4O4CShsZUobHxhdMV/dIUP3ZK0/XXmESfdmwn94Bw=;
        b=9+EP/9IU+Wap0lqfMoKRskSPj1hsBBWZxjdUehUIB392D2G8M463pnNFjH9LBnNVW83pgX
        laU6yjwgpHOTX3AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2B12F13440;
        Tue, 21 Mar 2023 15:25:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PtsNCWjMGWSrVwAAMHmgww
        (envelope-from <jroedel@suse.de>); Tue, 21 Mar 2023 15:25:28 +0000
Date:   Tue, 21 Mar 2023 16:25:26 +0100
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <jroedel@suse.de>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     amd-sev-snp@lists.suse.com, linux-coco@lists.linux.dev,
        kvm@vger.kernel.org
Subject: Re: [ANNOUNCEMENT] COCONUT Secure VM Service Module for SEV-SNP
Message-ID: <ZBnMZsWMJMkxOelX@suse.de>
References: <ZBl4592947wC7WKI@suse.de>
 <ZBnH600JIw1saZZ7@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBnH600JIw1saZZ7@work-vm>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dave,

On Tue, Mar 21, 2023 at 03:06:19PM +0000, Dr. David Alan Gilbert wrote:
> Interesting; it would have been nice to have known about this a little
> earlier, some people have been working on stuff built on top of the AMD
> one for a while.

Sorry for that, we wanted to have it in a state where it could at least
boot an SMP Linux guest. It took us some more time to get the
foundations right and get to that point.

> You mention two things that I wonder how they interact:
> 
>   a) TPMs in the future at a higher ring
>   b) Making (almost) unmodified guests
> 
> What interface do you expect the guest to see from the TPM - would it
> look like an existing TPM hardware interface or would you need some
> changes?

For a) without b) the guest interface will be the SVSM TPM protocol. The
ring-0 code will forward any request to the TPM process and return to
the guest when it is done.

For b), or the paravisor mode, this is the vision, which is probably
more than a year out. The idea behind that is to be able to emulate what
Hyper-V is doing to boot Windows guests under SEV-SNP on an open source
SW stack.

How the TPM interface will look like for that paravisor mode is not
clear yet. In theory we can emulate a real TPM interface to make this
work, but that is not sure yet.

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

