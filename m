Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371D69EF5A
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 17:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730038AbfH0Ptm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 11:49:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22067 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728939AbfH0Ptl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 11:49:41 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F59A301E12B;
        Tue, 27 Aug 2019 15:49:41 +0000 (UTC)
Received: from flask (unknown [10.43.2.55])
        by smtp.corp.redhat.com (Postfix) with SMTP id AC9704F88;
        Tue, 27 Aug 2019 15:49:38 +0000 (UTC)
Received: by flask (sSMTP sendmail emulation); Tue, 27 Aug 2019 17:49:37 +0200
Date:   Tue, 27 Aug 2019 17:49:37 +0200
From:   Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [GIT PULL] Please pull my kvm-ppc-fixes-5.3-1 tag
Message-ID: <20190827154937.GA65641@flask>
References: <20190827095338.GA22875@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827095338.GA22875@blackberry>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Tue, 27 Aug 2019 15:49:41 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

2019-08-27 19:53+1000, Paul Mackerras:
> Paolo or Radim,
> 
> Please do a pull from my kvm-ppc-fixes-5.3-1 tag to get one small
> commit which I would like to go to Linus for 5.3 if possible, since it
> fixes a bug where a malicious guest could cause host CPUs to hang
> hard.  The fix is small and obviously correct.

Pulled, thanks.
