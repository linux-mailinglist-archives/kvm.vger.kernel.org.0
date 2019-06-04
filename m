Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEA0344CA
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 12:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfFDKwp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 06:52:45 -0400
Received: from foss.arm.com ([217.140.101.70]:40206 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727107AbfFDKwo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 06:52:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6ADBC80D;
        Tue,  4 Jun 2019 03:52:44 -0700 (PDT)
Received: from [10.1.196.129] (ostrya.cambridge.arm.com [10.1.196.129])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B3D9C3F5AF;
        Tue,  4 Jun 2019 03:52:41 -0700 (PDT)
Subject: Re: [PATCH v8 05/29] iommu: Add a timeout parameter for PRQ response
To:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>
Cc:     "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Robin Murphy <Robin.Murphy@arm.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        Vincent Stehle <Vincent.Stehle@arm.com>
References: <20190526161004.25232-1-eric.auger@redhat.com>
 <20190526161004.25232-6-eric.auger@redhat.com>
 <20190603163214.483884a7@x1.home>
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Message-ID: <13428eef-9b95-0f79-bebf-317a2205673a@arm.com>
Date:   Tue, 4 Jun 2019 11:52:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603163214.483884a7@x1.home>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/06/2019 23:32, Alex Williamson wrote:
> It doesn't seem to make much sense to include this patch without also
> including "iommu: handle page response timeout".  Was that one lost?
> Dropped?  Lives elsewhere?

The first 7 patches come from my sva/api branch, where I had forgotten
to add the "handle page response timeout" patch. I added it back,
probably after Eric sent this version. But I don't think the patch is
ready for upstream, as we still haven't decided how to proceed with
timeouts. Patches 6 and 7 are for debugging, I don't know if they should
go upstream.

Thanks,
Jean
