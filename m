Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E845D10970A
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2019 00:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfKYXo4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 18:44:56 -0500
Received: from ozlabs.org ([203.11.71.1]:50705 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfKYXo4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 18:44:56 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47MNtY50Fkz9sPV; Tue, 26 Nov 2019 10:44:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1574725493; bh=H0QyQZrbeMLVEdK70hv6tDvIQpWHiee/G/DrbEV/8BI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uOo7xlxOfPMjsE4gK1OsOgD9GFimIrHC86U59byhtfIN3KLJbJdgJ7aU4k3btrNIz
         Z/JLKj+4kVQXPf+ApHwKVjVxv3h/Bp9VccSeUyf6TJga/+HUbzCwQl6SNOBY6dPDQi
         9LGI6L3MqxUCrDbHf4rZUzziRt2Ue41yWmcJ18hBmse2+SkDSr4AdvsPMBZ8utRkba
         Apf17puAr9d/Vmy4qPzZZok7U6cW8zqXEjl6+pRcHwNB2r7DgHr8Px/WjAFcothlhs
         sp6pKkqlvIHQHwRApFAo4VFAAtDVlsqZz7eIbCuHnoM2jW/lvDQFBOCjf3uK5WQJAB
         PHUIXGmbAL+Nw==
Date:   Tue, 26 Nov 2019 10:44:51 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Greg Kurz <groug@kaod.org>,
        Bharata B Rao <bharata@linux.ibm.com>
Subject: Re: [GIT PULL] Please pull my kvm-ppc-next-5.5-2 tag
Message-ID: <20191125234451.GA11896@blackberry>
References: <20191125005826.GA25463@oak.ozlabs.ibm.com>
 <eff48bca-3ef0-8ae4-79d4-5e8087bded1a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eff48bca-3ef0-8ae4-79d4-5e8087bded1a@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 25, 2019 at 11:29:38AM +0100, Paolo Bonzini wrote:
> On 25/11/19 01:58, Paul Mackerras wrote:
> 
> Yes, of course (I have even accepted submaintainer pull request for new
> features during the first week of the merge window, so not a problem at
> all).

In that case, I have a patchset from Bharata Rao which is just now
ready to go in.  It has been around for a while; Bharata posted v11
yesterday, and we would really like it to go in v5.5, but I thought we
were too late.  If you're OK with taking it at this stage then I'll
send you another pull request.

Thanks,
Paul.
