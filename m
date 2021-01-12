Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943B92F23ED
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 01:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbhALA1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 19:27:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:40996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbhALA1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 19:27:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2746C22D49;
        Tue, 12 Jan 2021 00:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610411209;
        bh=8SIf2TTWWqiqMK2vhuQElzWPcH4QmiAT927JgE3F9pY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZbuLkPOEQ7Z0M0dW4uCvQ+VZkToYdSAKRInDXg0q8a+BwEvF58POEo+rcr/8oCl7e
         /BaANW16zOBslYMMy3ASNWC7UunHi5gfDc9OVsLbX6H1Y1iYMIegT8LEipE+CaA+7n
         rvcQKxOqKBXAMTNRMc4OWQEP4itC4GtYRKwUjvEfWiefTMBcG1GQmpsmIkktF6NH4c
         1bZFxv1vsxAmWRLfkwZGV7jL8MgHxqlc6USly0pn6ga58nQoqeum7bUVRXaBjQGgQD
         /sYoI2Bo9/adUKcqxDtcAfcpVFLS6XVBLr+M5hqI45i9JGjiXQT3TjJjRbWbSKXGl7
         xaT35ubXoNdZA==
Date:   Tue, 12 Jan 2021 02:26:43 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        luto@kernel.org, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH 02/23] x86/sgx: Add enum for SGX_CHILD_PRESENT error
 code
Message-ID: <X/zsw6J2qFOXSamE@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
 <2a41e15dfda722dd1e34feeda34ce864cd82361b.1609890536.git.kai.huang@intel.com>
 <05f6945b-418a-b4eb-406a-0f0a23cb939f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05f6945b-418a-b4eb-406a-0f0a23cb939f@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 06, 2021 at 10:28:55AM -0800, Dave Hansen wrote:
> On 1/5/21 5:55 PM, Kai Huang wrote:
> > Add SGX_CHILD_PRESENT for use by SGX virtualization to assert EREMOVE
> > failures are expected, but only due to SGX_CHILD_PRESENT.
> 
> This dances around the fact that this is an architectural error-code.
> Could that be explicit?  Maybe the subject should be:
> 
> 	Add SGX_CHILD_PRESENT hardware error code

Yeah, a valid point. Please, change this.

/Jarkko
