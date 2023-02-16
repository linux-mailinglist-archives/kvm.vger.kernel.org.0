Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03303699116
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 11:24:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBPKYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 05:24:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjBPKYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 05:24:44 -0500
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0EC4010A9F
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 02:24:43 -0800 (PST)
Received: from 8bytes.org (p200300c27714bc0086ad4f9d2505dd0d.dip0.t-ipconnect.de [IPv6:2003:c2:7714:bc00:86ad:4f9d:2505:dd0d])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 50A152246CC;
        Thu, 16 Feb 2023 11:24:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1676543082;
        bh=EIBMPAdejZ5+9OgpAb995sNA/DVRf/RwDbao+hnEl4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GRgl/tinAxLX/gzt+IP97trFOZTuitOSHhZog35pcKzVdWhaUkoJbJZAfO3kJN8IV
         qRW3LP0GY6wmGVI0qp0wt8kVF0DuBW5evJpPa9oHgdmw50w1+vBsPfoFqTApaDos8s
         S5ut/jjU5nElieNywKOQdjWirdrok9q0PGpPWXTFGcJJb4j9Ch3/s4YO76dthVBFcD
         PdLJG1QlFEK8+fh1LcBXDq8bWU1jpJGHm/mYSMIhu6tcqBunFeIlUTLcdgoDinuw5T
         4hkjHTPVmY2E3QL3uTJNQbgih/xFdDfzW7DvUXLR4uqwKu+FTifTuy4XVi/1gKlrNY
         qlkvS2uRCTa9g==
Date:   Thu, 16 Feb 2023 11:24:41 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Vasant Hegde <vasant.hegde@amd.com>, iommu@lists.linux.dev,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v1] iommu/amd: Don't block updates to GATag if guest mode
 is already on
Message-ID: <Y+4EaSuEj9V8REf0@8bytes.org>
References: <20230208131938.39898-1-joao.m.martins@oracle.com>
 <Y+3+xtof4tC8koSj@8bytes.org>
 <6f5da7c9-cec0-3034-ca58-41115c565df5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f5da7c9-cec0-3034-ca58-41115c565df5@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 16, 2023 at 10:08:11AM +0000, Joao Martins wrote:
> On 16/02/2023 10:00, Joerg Roedel wrote:
> > Missing Signed-off-by.
> > 
> 
> Not really missing it. It's actually there, right after the 'Fixes' tag.

Right, missed the separator to the notes part.

