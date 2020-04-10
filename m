Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0B11A432D
	for <lists+kvm@lfdr.de>; Fri, 10 Apr 2020 09:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbgDJHtJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Apr 2020 03:49:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbgDJHtJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Apr 2020 03:49:09 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 68E29206F7;
        Fri, 10 Apr 2020 07:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586504949;
        bh=/o4MJjPAlTLNfcD2ikCDJYX0S8Gr3CyOaOCNkkDz0Jc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NQ9vml3bCC4VDaG2BqN645+mMUE6sKKHbLVCUvwUCf51HE/GyRO4f88ruKh/oPVLG
         wanjjheIR0E/367gnxUADdTUUR0vZLn0jQZmoA0cGx25d8GH2zafWTx7Kso1tq4Hlu
         irLlS3fqI3joTgr6nvTTo/mzEDlCXXl5bMokQwfI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jMoPT-0027iL-GW; Fri, 10 Apr 2020 08:49:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 10 Apr 2020 08:49:07 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Javier Romero <xavinux@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Subject: Re: Contribution to KVM.
In-Reply-To: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
Message-ID: <548a7864dce9aaf132f90fbb67bd3f52@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: xavinux@gmail.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Javier,

On 2020-04-09 22:29, Javier Romero wrote:
> Hello,
> 
>  My name is Javier, live in Argentina and work as a cloud engineer.
> 
> Have been working with Linux servers for the ast 10 years in an
> Internet Service Provider and I'm interested in contributing to KVM
> maybe with testing as a start point.
> 
> If it can be useful to test KVM on ARM, I have a Raspberry PI 3 at 
> disposal.

Testing is great (although the RPi-3 isn't the most interesting platform 
due
to its many hardware limitations). If you are familiar with the ARM 
architecture,
helping with patch review is also much appreciated.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
