Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15211308B1
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 08:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfEaGiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 02:38:02 -0400
Received: from ozlabs.org ([203.11.71.1]:54599 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbfEaGiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 May 2019 02:38:01 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 45FZWp6VsPz9sNp; Fri, 31 May 2019 16:37:57 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1559284678; bh=Wg0dD2kUteHV47XJIEXRJJ+H0gagR/UFdiDS7MN8yvQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rCn5C5sdi34wFkiByiFcMK2f2s/czqduKRwydD/RgmZ8XFFKpuI26jAIkgDML+RRj
         4SY/FM9MB6zN/vPoHJhhuDQK37ZERtTWJF8pwB/ARwhF5KtxjENw1ToWF3vI4MaFTG
         jSryoylxrg9H5hQNBMJcgrYLHHo8SZxDGTQcJ8A01kEko6YmiGtAIdVdme8RjfvppF
         ggxRdjK/bLeQZTDeCruVOkHTPLUenCWJj/PzkO90PLnNkxSUga3M2n1SZLa3t+4z0v
         tSdIRG8+8UzC2v9B4InC9wyH7LxbaOqXYwlHAQQhILL8zXlM9PA/QxToPB2H3CNsOQ
         ZCw6ilsYHh9RA==
Date:   Fri, 31 May 2019 16:33:38 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     =?iso-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>
Cc:     kvm-ppc@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: PPC: Book3S HV: XIVE: assorted fixes on vCPU
 and RAM limits
Message-ID: <20190531063338.GC26651@blackberry>
References: <20190520071514.9308-1-clg@kaod.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190520071514.9308-1-clg@kaod.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 20, 2019 at 09:15:11AM +0200, Cédric Le Goater wrote:
> Hello,
> 
> Here are a couple of fixes for issues in the XIVE KVM device when
> testing the limits : RAM size and number of vCPUS.
> 
> Based on 5.2-rc1.
> 
> Available on GitHub:
> 
>     https://github.com/legoater/linux/commits/xive-5.2
> 
> Thanks,
> 
> C. 
> 
> Cédric Le Goater (3):
>   KVM: PPC: Book3S HV: XIVE: clear file mapping when device is released
>   KVM: PPC: Book3S HV: XIVE: do not test the EQ flag validity when
>     reseting
>   KVM: PPC: Book3S HV: XIVE: fix the enforced limit on the vCPU
>     identifier

Thanks, series applied to my kvm-ppc-fixes branch.

Paul.
