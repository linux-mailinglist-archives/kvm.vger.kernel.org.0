Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898952A4C5C
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 18:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgKCRKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 12:10:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23120 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727323AbgKCRKP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Nov 2020 12:10:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604423414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q/Q5NAWcRyKms4gzbcNHGF8FbyybB7ZnLZtG56LD+jY=;
        b=XrV3zh990/phLwdKNydGUptmmgD09gb+Gmr33D0EVt+tEDMCNadV4C8Bw/iovMOm83zRPH
        Scg0zbkqqfnHx/Q6So3YPSGc8aQJ8WgaLelslbU8KzKLqkGuuQFR+vNkODDred+PJ4icSa
        RMGHbv0pnHV6ZzMx72FqQJmnWAI7lTk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-445-GNSX3hk8NnWK5Y4D2yyeEg-1; Tue, 03 Nov 2020 12:10:12 -0500
X-MC-Unique: GNSX3hk8NnWK5Y4D2yyeEg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5BB6918C9F41;
        Tue,  3 Nov 2020 17:10:11 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.252])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 719FA5B4A1;
        Tue,  3 Nov 2020 17:10:09 +0000 (UTC)
Date:   Tue, 3 Nov 2020 18:10:05 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com,
        alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH 1/2] arm: Add mmu_get_pte() to the MMU API
Message-ID: <20201103171005.f3hwclcrb5cyqq56@kamzik.brq.redhat.com>
References: <20201102115311.103750-1-nikos.nikoleris@arm.com>
 <20201102115311.103750-2-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102115311.103750-2-nikos.nikoleris@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 02, 2020 at 11:53:10AM +0000, Nikos Nikoleris wrote:
> From: Luc Maranget <Luc.Maranget@inria.fr>
> 
> Add the mmu_get_pte() function that allows a test to get a pointer to
> the PTE for a valid virtual address. Return NULL if the MMU is off.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>

Reviewed-by: Andrew Jones <drjones@redhat.com>

