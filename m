Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49CB1323F89
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 16:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhBXOJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 09:09:03 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:11530 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbhBXNBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 08:01:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60364de30001>; Wed, 24 Feb 2021 05:00:19 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Feb
 2021 13:00:19 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 24 Feb 2021 13:00:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ekr4J8ELrYx5LtD7zgzq37/rV/wU69b+xbBiU41JRI9wPhmFEQ5DK7PDqlfn7EJXzjmq6UNHUvuGI9zZJKSw+H3lYRJRtanZBOSynONRXRnTe76jR0grNU5UlT91rT+aeYNcy8dc4txVjoc7pTcQ+L/HkJZAPaVrNwByXqYING24u77UP1mKmOZAqeH9yxvNEXO0mhHbM1qLSLfCCcStJkyJaN1TpObu4imF9G8pm+QLeG2H9HbgMXn+hPKRo4gjVz9wPgsJROKTTPF18+coEQ6ZbCFCqbIUpVhtX5hWWFfvmyIMZG4LHf0DOJRFXca3aVD60pE8Z7vaATccmZnexg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXDoUMTRaO7xCKbxZPqwlzAv3JXVbcMH15jIhmSrnjE=;
 b=Kxb5sbFacXaCYhb7SniIZmSDZ9+Ft39tN+jlF8Fvbjfy/d7D34HpSs0SQRcncQ7h9qvv+pmWH7OGSjCfiNO8PDhaZjgNXOcu/hkSe2TCh9yYup/OPVFRRxQuTcKwzv+2MxgMT+tu2q2aQ9lxdfxHk7BlzeNVnQ0wqwQEqSrfLEZO96LAp55yu6PC0TQ2u4VgcU2O4fOmxUaBQtPnvqeDKz7xPvJuVtPZyn2EcNw2jNt73lI6k4JyXdygu7AJ5x9gldrqRMGheM0Iw7XjEQoxhF3zLhsfsjhRbTMZ00W3e+t0dBcXSPIPp6fJRv5enKbwOP1RQeysE4UNUOpxwRBx2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0108.namprd12.prod.outlook.com (2603:10b6:4:58::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.33; Wed, 24 Feb
 2021 13:00:18 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3868.033; Wed, 24 Feb 2021
 13:00:18 +0000
Date:   Wed, 24 Feb 2021 09:00:16 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Auger Eric <eric.auger@redhat.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/3] vfio-platform: Add COMPILE_TEST to VFIO_PLATFORM
Message-ID: <20210224130016.GK4247@nvidia.com>
References: <2-v1-df057e0f92c3+91-vfio_arm_compile_test_jgg@nvidia.com>
 <8b7dad1c-6597-49a5-15ba-715fcb3e478b@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8b7dad1c-6597-49a5-15ba-715fcb3e478b@redhat.com>
X-ClientProxiedBy: BL1PR13CA0404.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::19) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0404.namprd13.prod.outlook.com (2603:10b6:208:2c2::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.10 via Frontend Transport; Wed, 24 Feb 2021 13:00:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lEtm4-00GgNv-Jp; Wed, 24 Feb 2021 09:00:16 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1614171619; bh=xXDoUMTRaO7xCKbxZPqwlzAv3JXVbcMH15jIhmSrnjE=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=Cqd2F5y6giOmKLfQeryIusOF6uJPrU0axU74aDigrfKt6UOD8ahhRYRjLBz6jDXRL
         2xF4k+jN9mr6REurgovISImFBV26tpupxTQyHNtVlbqv4I+ev5b+YwcDlykkE9i9sU
         JBPqJNyMG1H8fZlr5OEUSONeF0TlCxCpbMvzThQCRNbQGy0pN2duE3QYFhP5xQgsmc
         IDNJoSnBqbyG3FCMbuLM1rdKdh0o9xc5OWMqTwVkAVVv1CYrwvMlgbufpYdgk8N3HG
         X7uz898KI3LHejlh6zPP8GKI6jszhxkROtnZUa67sWqtUOXP0UFW0vzE8HNKND2mKX
         XxQetf9+Hm/Rg==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 24, 2021 at 10:42:10AM +0100, Auger Eric wrote:
> Hi Jason,
> On 2/23/21 8:17 PM, Jason Gunthorpe wrote:
> > x86 can build platform bus code too, so vfio-platform and all the platform
> > reset implementations compile successfully on x86.
> 
> A similar patch was sent recently, see
> [PATCH v1] vfio: platform: enable compile test
> https://www.spinics.net/lists/kvm/msg230677.html

Well, it does look like it got lost/abandoned, so lets focus on this
series.

Thanks,
Jason
