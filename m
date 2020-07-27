Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1618122EAF2
	for <lists+kvm@lfdr.de>; Mon, 27 Jul 2020 13:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgG0LPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jul 2020 07:15:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgG0LPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jul 2020 07:15:45 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAC5020663;
        Mon, 27 Jul 2020 11:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595848544;
        bh=oJnFe7i2aMyPNt4qncXo7Nnv+J187zuVdYAjcMJGEog=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fRiKrLaRN9c/GvrICVrJSLTc55ZFQFuQON/4BaIiBrtP6q28Jr3zUZmCxBjP+ri9z
         3VxplHU0ecP2s0v6GzvSCuDryvc84p4JGz2f1xD2bGxO5u16i9xcXIfw/408fUwVeI
         flw/Qlhv2goKHpiBHjAwfQ3R3nv+pyXKFZn1QjM8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k016c-00FHAN-RG; Mon, 27 Jul 2020 12:15:43 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 27 Jul 2020 12:15:42 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 0/5] KVM: arm64: pvtime: Fixes and a new cap
In-Reply-To: <20200727110224.vpsakrqaj2vm7g66@kamzik.brq.redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <20200727110224.vpsakrqaj2vm7g66@kamzik.brq.redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <4171d397a22c78c242dee9f161372663@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com, steven.price@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-27 12:02, Andrew Jones wrote:
> Hi Marc,
> 
> Ping?

On it! ;-)

         M.
-- 
Jazz is not dead. It just smells funny...
