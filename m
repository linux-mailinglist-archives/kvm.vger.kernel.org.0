Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB9D10F4C1
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 03:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfLCCB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 21:01:27 -0500
Received: from ozlabs.org ([203.11.71.1]:46703 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfLCCB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 21:01:27 -0500
Received: by ozlabs.org (Postfix, from userid 1003)
        id 47RlZs373Nz9sPL; Tue,  3 Dec 2019 13:01:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1575338485; bh=Z6g4P0kR+Lg+jlbqbIwnOiPZH4g0NSoRsPlrdMM7fKE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SDDFe2OdZq8eVHSJtT+Y5e2lBTNlv7yciWKq/NK4/0VyZPwQ0QCb5B8I0/4Oj8c3t
         AH+rE4NBzRbBS3ptx7dJ6yMxEQC6E6szdJmAKcMeC0oTgz/LSdtXiw6nU/0RxxTHeh
         D7xVntyWFtAao18ZjE50CK5lbypwytrM/JpDDbPC/99EqEap5jY0Z5RfDiwDkXBott
         lA3d2lpJ7klcpZCTRGYso2hEnupQcKsZzIT7xEKloA6+E1q0kqsubD1GYH66Uwux05
         mF/7tyxumgyO62ZmZJDFV2mLvOzzWwHVqbdq55LQ4aSJFQcG3dTtfjS/Dz+ShwcZjZ
         B0yrscbv1xOOA==
Date:   Tue, 3 Dec 2019 13:01:21 +1100
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Wayne Li <waynli329@gmail.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: KVM Kernel Module not being built for Yocto Kernel
Message-ID: <20191203020121.GA14683@oak.ozlabs.ibm.com>
References: <CAM2K0nqWjaPB3gFD4m6DjciJUCpix4MaGr0hZkp20PxObtL1Zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM2K0nqWjaPB3gFD4m6DjciJUCpix4MaGr0hZkp20PxObtL1Zw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 02, 2019 at 09:47:50PM +0000, Wayne Li wrote:
> Dear KVM community,
> 
> First of all I'd like mention I've posted this question on the Yocto
> mailing list as well as the KVM mailing list because my question has
> huge ties to the bitbake process (a concept related to the Yocto
> project).  Though I believe I'm mainly addressing the KVM community
> because my problem is more directly related to the intricacies of the
> KVM build process.
> 
> So I am trying to build the kvm-kmod from source and I'm running into
> an issue where the compilation doesn't produce any kernel modules.
> But before I describe my issue and question any further, here's a
> little background information on my current endeavour.
> 
> My goal right now is to get KVM to work on a T4240RDB running on a
> Yocto-based kernel.

So... what kernel version are you using?

What sub-architecture is the T4240RDB?

What kernel config options are you trying to turn on?

Paul.
