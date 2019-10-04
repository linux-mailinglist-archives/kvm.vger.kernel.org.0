Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34F21CC10C
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 18:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfJDQtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 12:49:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfJDQtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 12:49:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7EDF83082137;
        Fri,  4 Oct 2019 16:49:16 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B5AC60852;
        Fri,  4 Oct 2019 16:49:15 +0000 (UTC)
Date:   Fri, 4 Oct 2019 18:49:13 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/6] arm: gic: check_acked: add test
 description
Message-ID: <20191004164913.ncdtolqkhgymso46@kamzik.brq.redhat.com>
References: <20191004141829.87135-1-andre.przywara@arm.com>
 <20191004141829.87135-2-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004141829.87135-2-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 04 Oct 2019 16:49:16 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 04, 2019 at 03:18:24PM +0100, Andre Przywara wrote:
> At the moment the check_acked() IRQ helper function just prints a
> generic "Completed" or "Timed out" message, without given a more
> detailed test description.
> 
> To be able to tell the different IRQ tests apart, and also to allow
> re-using it more easily, add a "description" parameter string,
> which is prefixing the output line. This gives more information on what
> exactly was tested.
> 
> This also splits the variable output part of the line (duration of IRQ
> delivery) into a separate INFO: line, to not confuse testing frameworks.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
