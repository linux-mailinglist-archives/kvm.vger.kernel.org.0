Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7722CC111
	for <lists+kvm@lfdr.de>; Fri,  4 Oct 2019 18:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfJDQvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 12:51:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfJDQvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 12:51:32 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C50D1308219E;
        Fri,  4 Oct 2019 16:51:32 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B4E4C5D9DC;
        Fri,  4 Oct 2019 16:51:31 +0000 (UTC)
Date:   Fri, 4 Oct 2019 18:51:29 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 2/6] arm: gic: Split variable output
 data from test name
Message-ID: <20191004165129.ocqn37t5gaq66wxf@kamzik.brq.redhat.com>
References: <20191004141829.87135-1-andre.przywara@arm.com>
 <20191004141829.87135-3-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191004141829.87135-3-andre.przywara@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 04 Oct 2019 16:51:32 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 04, 2019 at 03:18:25PM +0100, Andre Przywara wrote:
> For some tests we mix variable diagnostic output with the test name,
> which leads to variable test line, confusing some higher level
> frameworks.
> 
> Split the output to always use the same test name for a certain test,
> and put diagnostic output on a separate line using the INFO: tag.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/gic.c | 45 ++++++++++++++++++++++++++-------------------
>  1 file changed, 26 insertions(+), 19 deletions(-)
>

Reviewed-by: Andrew Jones <drjones@redhat.com>
