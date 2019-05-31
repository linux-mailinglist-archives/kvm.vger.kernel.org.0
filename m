Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABEE308B4
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 08:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfEaGiD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 02:38:03 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:39583 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbfEaGiC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 02:38:02 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45FZWq6gLRz9sP0; Fri, 31 May 2019 16:37:58 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1559284679; bh=HdJ9JTlKPTsMYfopsBDM8ysZi48X790cH9p1B4LgFdk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hi33gZA5RDPozK5fsByV5Y0Nsk4idB/x5YZOpG0J0sD3B8FQkiu/SWudojhZZ8XIp
         XOoj2EkDZPrTm4ojXwk0+wwdronHfnW9p/OFv/3LUAXv98DrtLbd5DByVpbkWkkUli
         nxEaeor2bbhlwuZusoROM9jp1zYxTPe+zeZo3dhV0i/LxxAMpup0wxv86dIPhSLciM
         fKkkC4L96G6CwjPquhfQnSbmIOJbpT7XTeZetMsbyunzrv8y0X4SB7t8iyduU4kRwY
         cdyA3kfl1fkRTnRtttKZ9b5vdJ1mWs1H1AYDAn/lrl0C/4RMzRAQzikVJo7nmwpGUb
         mM1d4DfFk5kmg==
Date:   Fri, 31 May 2019 16:32:07 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org,
        =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Subject: Re: [PATCH 0/4] KVM: PPC: Book3S: Fix potential deadlocks
Message-ID: <20190531063207.GB26651@blackberry>
References: <20190523063424.GB19655@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523063424.GB19655@blackberry>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 23, 2019 at 04:34:24PM +1000, Paul Mackerras wrote:
> Recent reports of lockdep splats in the HV KVM code revealed that it
> was taking the kvm->lock mutex in several contexts where a vcpu mutex
> was already held.  Lockdep has only started warning since I added code
> to take the vcpu mutexes in the XIVE device release functions, but
> since Documentation/virtual/kvm/locking.txt specifies that the vcpu
> mutexes nest inside kvm->lock, it seems that the new code is correct
> and it is most of the old uses of kvm->lock that are wrong.
> 
> This series should fix the problems, by adding new mutexes that nest
> inside the vcpu mutexes and using them instead of kvm->lock.

Series applied to my kvm-ppc-fixes branch (with v2 of 3/4).

Paul.
