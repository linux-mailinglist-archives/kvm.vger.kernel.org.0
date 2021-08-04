Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896743E021C
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 15:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238235AbhHDNfR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 09:35:17 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:50306 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbhHDNfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 09:35:16 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2691E2220B;
        Wed,  4 Aug 2021 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628084103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RlYID6H9Q0Lws9JHck3V456EbJP+KpHpX3NPkST1zUI=;
        b=cK0N8bMLrKmh3ycXsAt922GLqCzXJP65+i+41/93uKkPr/0fcNgjJuQg/tQyyhAlmB/D2l
        b9gtvRH3bcv7sJkSXxIfkvg1zfgD/loO5U6ZfnxPwV2eAIDUP2fG41bgnzZ65NkGHXGzNQ
        qZPMTWTHX6QarvSA/glE5jNsL/xZcZ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628084103;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RlYID6H9Q0Lws9JHck3V456EbJP+KpHpX3NPkST1zUI=;
        b=AVG0yZNYlSzizw8vcP+WKK1y75EBAnVMT3xaDSabQvzskiYfSZH9MvYlmp3DGXDSCYYs2P
        t6pWN+DhbDim0hAA==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id EE86213942;
        Wed,  4 Aug 2021 13:35:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id EoFyOIaXCmEqPwAAGKfGzw
        (envelope-from <jroedel@suse.de>); Wed, 04 Aug 2021 13:35:02 +0000
Date:   Wed, 4 Aug 2021 15:35:01 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [bug report] x86/sev: Split up runtime #VC handler for correct
 state tracking
Message-ID: <YQqXhadHZ1Ya/NEn@suse.de>
References: <20210804095725.GA8011@kili>
 <YQqKS7ayK1qkmNzv@suse.de>
 <20210804125834.GF22532@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804125834.GF22532@kadam>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 03:58:34PM +0300, Dan Carpenter wrote:
> Hm...  Ok.  Let give you the rest of the call tree then because I'm not
> seeing where it checks preempt count.

The check is in faulthandler_disabled(), it checks for in_atomic().

Regards,

	Joerg

