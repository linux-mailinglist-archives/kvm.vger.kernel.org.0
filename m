Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF4B26BAEA
	for <lists+kvm@lfdr.de>; Wed, 16 Sep 2020 05:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbgIPDtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 23:49:15 -0400
Received: from mail-eopbgr700085.outbound.protection.outlook.com ([40.107.70.85]:21633
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726486AbgIPDtK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 23:49:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nnz8h2XonpjJwQ+91YXLmhi5B5HkqFrJTLjCA3qQdcyvSwCaUPYN6cebgxMJCM8CFh6a+0K5t1tAIXRrMUFbOuczqxE9f9HePTrcd52xBTOZOY6sQBGtqNG3czyvUVNLgwCmWZisq41IaMsp/u2MB9S9mnh559Njv7CLSaoQER1F4GuUx5sRKReNOKA+ZV6faAJr123yDtjiGzqjtcbGmG7BhXlX4ChLbj9KVxbYpNSkX3bM67+xIQdBd4GGrnAwMzW4P5anJKw490cB4jVrn0DMC/T1jjunmZdUe5j0ymitfeiupUa6OyFYgzD2aZK5jOKd2u4/RJzOaXL5PlELsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZ/D+Q/kmxLiYd4w8gULC0EeonEBJFusdeCRLhEqmXk=;
 b=F29z9NyNSpDtEN0bkYMdeRew8/xSGeX2InDkDWnVirMX6YA5jDOSvmMOEl3XxWwgUr6+sDwWJetk27lydVI6poauE8G+MZKbgYq9SXIB4biCBQPmllffQMguG6nTObUpryWUeudAS3/GanPBU5WH8/E4ufzsy584sOtCmsh742X8Gk21IzNlVFTP1VNWwvE2w717x09+8VD9HWWKXCGtCMI+Kb4+j7eJpdkyv/cqnfGsbdQfm5FwVW8QVqMM3MFIkmYKw0aFXa0DQm8uSdaeTSH6EudNIsuo4FjLdMgw0n+WnuA2xe2r1gnA7mFexXO4pNP1NApV7rvk69FS+Zr8bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WZ/D+Q/kmxLiYd4w8gULC0EeonEBJFusdeCRLhEqmXk=;
 b=OqZ/dV7fOcsbxjo5j8/bcmy4pUw8cXqgNuiUUZclafszmCndf62GJzsoE4h4hYp9DP2asrkBkg3BPoRAt/p2SHhTiVC2yFIS2VcpdwSr1eoShIKMpYSAaYFIZIjujVRBcJuiTP56QL3LPiqnCA5wi9sSL15fOZZ3vQT9cWWoaHk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR1201MB0215.namprd12.prod.outlook.com (2603:10b6:910:1d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Wed, 16 Sep
 2020 03:49:08 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::9067:e60d:5698:51d8]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::9067:e60d:5698:51d8%12]) with mapi id 15.20.3391.011; Wed, 16 Sep
 2020 03:49:08 +0000
Date:   Tue, 15 Sep 2020 22:49:05 -0500
From:   Wei Huang <wei.huang2@amd.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, Wei Huang <whuang2@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/2] KVM: x86: allow for more CPUID entries
Message-ID: <20200916034905.GA508748@weilap>
References: <20200915154306.724953-1-vkuznets@redhat.com>
 <20200915165131.GC2922@work-vm>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915165131.GC2922@work-vm>
X-ClientProxiedBy: MN2PR01CA0008.prod.exchangelabs.com (2603:10b6:208:10c::21)
 To CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
Importance: high
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (24.55.15.93) by MN2PR01CA0008.prod.exchangelabs.com (2603:10b6:208:10c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Wed, 16 Sep 2020 03:49:07 +0000
X-Priority: 1 (Highest)
X-MSMail-Priority: High
X-Originating-IP: [24.55.15.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3cd52300-2c18-488c-d81d-08d859f376e5
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0215:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0215BFD0762A668FE2562808CF210@CY4PR1201MB0215.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nA+gc7Tsuiz3vv5+wFVjSXjDyuZSZ4+wVtiGNF+Xe5vgXZ2QjpZepA3CGVqJi2/BPZawafWhuBJnNlJA1NXwDTgx9S8ZG3l5bnHsamW2oSzp69TRIV1cv8vRJUHnT7purFou1N5tlEVV4yFM8D3DtK3xyw3lzEV3XuxfPXtHN6ZyLYM6oa4srswHWna/LX+tac2gwxZtOMuYQBTMde3r4fruvejRvYNpHTKpW7BpJ1e5vGt954WRn3XRHYF1R96NJqjiSnSVTuqC3AGHVSEmzks+J9Kt9nKc+6vNBeUa+pgB1zHj6/roTeHFEOq0c9WhDiLDE+rVeh26fG1peAUZMCb5UR9n0K8+xGH6tKNcu8kdzF9lKIYnyfDmHAeQZiWh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(39860400002)(366004)(396003)(376002)(346002)(136003)(83380400001)(6486002)(16526019)(186003)(66946007)(478600001)(66476007)(66556008)(26005)(52116002)(54906003)(6496006)(33716001)(8676002)(8936002)(4326008)(6916009)(956004)(9686003)(33656002)(2906002)(86362001)(5660300002)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DduOcOfHhAHGl+yT6reauo6b4Nmq1EYHIpwW2URmjcB/nYvENHtoS+UzGPA1L3Pec/FK1cBDXMjc4RPUyeTfdOkIEAXvKLdeeYEIOW998/SiRZFJWbdDB2YeCuN8QTeGAoi5gHRwxIX4zBpkjaU88ct3zhNC4Go053vZzX5Gz+XiG3ROdM6Lnr1cllZdwC5osafkiTwzgrcigusRzbAqVQaTntHStVuJbaE0ETa0JvsFcpLSWpY0AK2K+dnFC3U/Yef2RPViSwaDQE4vnIpkl80NST+MH+Ku1SilWJSN7Zp2/B0EdKxLMJ9eSpir1j5ylBFVG7Yca6zWD+ba1EQE3wVkKvw2Qf4J+DYc55OrtkdZDz7Ov7mkgaT6HQMWpbs4xbSEoNE33dCvF8Wol4iMHcmM82H6ECeQst1qajMejResr+KcMfFWpZe4HVoGGpnvI6lfCINYUNFAkWxha+jbIrggZkjoG4b9lbe1qk90fsRkYsAknnQ8SQcuKGtIoIDwEoMrFyGwsgR3DFjAfKwR47O7/AQtWc2plojxRoYmOPLbWJgDdcFOdbSeUoVwXXl09Ei2gqvHJF+k1sQ2XNHvblV84WvJu4i+bTX5zC81NHVUXSEW0hm4MM9ySVBl+KVa00b07DtoUX8gPqRhH8x80Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cd52300-2c18-488c-d81d-08d859f376e5
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2020 03:49:08.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lv6nzlFY2ijUfWwDOhnZhoyAOc67bMpzufQzJYakoeiiX4wt2P+CvU2QAH2+Z2sT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0215
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/15 05:51, Dr. David Alan Gilbert wrote:
> * Vitaly Kuznetsov (vkuznets@redhat.com) wrote:
> > With QEMU and newer AMD CPUs (namely: Epyc 'Rome') the current limit for

Could you elaborate on this limit? On Rome, I counted ~35 CPUID functions which
include Fn0000_xxxx, Fn4000_xxxx and Fn8000_xxxx.

> > KVM_MAX_CPUID_ENTRIES(80) is reported to be hit. Last time it was raised
> > from '40' in 2010. We can, of course, just bump it a little bit to fix
> > the immediate issue but the report made me wonder why we need to pre-
> > allocate vcpu->arch.cpuid_entries array instead of sizing it dynamically.
> > This RFC is intended to feed my curiosity.
> > 
> > Very mildly tested with selftests/kvm-unit-tests and nothing seems to
> > break. I also don't have access to the system where the original issue
> > was reported but chances we're fixing it are very good IMO as just the
> > second patch alone was reported to be sufficient.
> > 
> > Reported-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 
> Oh nice, I was just going to bump the magic number :-)
> 
> Anyway, this seems to work for me, so:
> 
> Tested-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> 

I tested on two platforms and the patches worked fine. So no objection on the
design.

Tested-by: Wei Huang <wei.huang2@amd.com>

> > Vitaly Kuznetsov (2):
> >   KVM: x86: allocate vcpu->arch.cpuid_entries dynamically
> >   KVM: x86: bump KVM_MAX_CPUID_ENTRIES
> > 
> >  arch/x86/include/asm/kvm_host.h |  4 +--
> >  arch/x86/kvm/cpuid.c            | 55 ++++++++++++++++++++++++---------
> >  arch/x86/kvm/x86.c              |  1 +
> >  3 files changed, 43 insertions(+), 17 deletions(-)
> > 
> > -- 
> > 2.25.4
> > 
> -- 
> Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK
> 
