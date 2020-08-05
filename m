Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEC5D23CF7A
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgHETV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:21:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728976AbgHERl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 13:41:59 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4823D22CBB;
        Wed,  5 Aug 2020 12:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596629618;
        bh=nPo8SyJqUjJ9z0rJpRBpkkeu083JsBlxNsr28VDgX9c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DN/pSFKGnrcuF/DioT3fQLhKd9KxDsJUYUl0Lo82SO0RrZoUoAMS0p+RF2oNdR7j9
         0icBWKv46n1IcKVg4n5Scb3ZM8QiZIQQXUbXpl5k3PXkczj+lJ2JkMAkJZ0vTFPAzo
         AI+uK6MDywGiCleiIYO1jyfFfMh3cLLcyGIfXtWI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3IIa-0001gS-Ol; Wed, 05 Aug 2020 13:13:36 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 05 Aug 2020 13:13:36 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
In-Reply-To: <957a4657-7e17-b173-ea4d-10c29ab9e3cd@huawei.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <957a4657-7e17-b173-ea4d-10c29ab9e3cd@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <0bd81d1da9040fce660af46763507ac2@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangjingyi11@huawei.com, drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com, wanghaibin.wang@huawei.com, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-08-05 12:54, Jingyi Wang wrote:
> Hi all,
> 
> Currently, kvm-unit-tests only support GICv3 vLPI injection. May I ask
> is there any plan or suggestion on constructing irq bypass mechanism
> to test vLPI direct injection in kvm-unit-tests?

I'm not sure what you are asking for here. VLPIs are only delivered
from a HW device, and the offloading mechanism isn't visible from
userspace (you either have an enabled GICv4 implementation, or
you don't).

There are ways to *trigger* device MSIs from userspace and inject
them in a guest, but that's only a debug feature, which shouldn't
be enabled on a production system.

         M.
-- 
Jazz is not dead. It just smells funny...
