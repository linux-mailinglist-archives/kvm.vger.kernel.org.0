Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B0EF83DA
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2019 01:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfKLAFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 19:05:14 -0500
Received: from mail-eopbgr750080.outbound.protection.outlook.com ([40.107.75.80]:3300
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726887AbfKLAFO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 19:05:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MTYF17Q6OyQvtsn3cU9LQcohgLKk8zGLTa0oBJPx/MhWmn+gVXFPChTzi5AkNmwh2A5dX41p9rnR5fLkJF3PK8tgeq/fU5IciwENU/hv0ZOJBbV/TYnywIb7nvccsyOrlU4HlDEKCnkuJK/ujsjFWa8Ru5Y1mWOH0gq0KLUaTOBaRRKbUc9sJlkt0U62X5W9oBGP4LcpUfZf6tEfyg2FhWsxeVSCndPe5YVPZK51wVUpXtFseyfwC+vcNDMy7bAu/TeUvR+jRIF8SgS8WxeQAf+1RjJ0VmIoX4gcylcTJxtnIRL8bkCDsdZpDWrjnnchLiC+zubPdlEd6usRbITwyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmp62GIKU10zl2WT532L6sEaOnbe7XWvnjkkTLWgYlU=;
 b=bYfcpQVA7fWaKI5LNJKXZPMuw9PpUN+/Up1NCIwIy2Cy/3Nm9j6nTEY4SF18uRdxLoC0xhZKFPyfrdnSJqoiF2HwGQVvuhoVP0bJYJYSbBuAzF1bRKTsRAEvgHEuemTxmniJAlRLcg+rdl5Y672DSOmpiCOsxDjCAQG+5kQMx6DyMYDW18PvyMG98rsD/+yqxv6FWoj8+wQj8nkYdPu9G5obd/u3yiAk8HQOFMToPjjL1rKnEpCCDhQQsuMTfl7TxdwrkUFRfjfHYvEsmAIJfMvgqxxSAMTucTRN0nKjNHqUVweujPRkeckhRjty/2kkCwsnwRXWkJbpa6BMjGvB6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cmp62GIKU10zl2WT532L6sEaOnbe7XWvnjkkTLWgYlU=;
 b=CSRLALhIF/86lcnWAtroiK3pA1R0GwR0DtzT5tq4PrxDguoSZTW7YFpKlpKg10JPee05cNQpw07/DHva1hkepaS9FVFW2CeSNXIQxsbreNd6UXrvmZJxEOXCtq/g65hzN8hx/Y7drAH0gIgX1kA6PfwLNfXmm191QpV4TMlrLFs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3722.namprd12.prod.outlook.com (10.255.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.23; Tue, 12 Nov 2019 00:05:11 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 00:05:10 +0000
Subject: Re: [PATCH v4 07/17] svm: Add support for setup/destroy virutal APIC
 backing page for AVIC
To:     "rkagan@virtuozzo.com" <rkagan@virtuozzo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "graf@amazon.com" <graf@amazon.com>,
        "jschoenh@amazon.de" <jschoenh@amazon.de>,
        "karahmed@amazon.de" <karahmed@amazon.de>,
        "rimasluk@amazon.com" <rimasluk@amazon.com>,
        "Grimm, Jon" <Jon.Grimm@amd.com>
References: <1572648072-84536-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1572648072-84536-8-git-send-email-suravee.suthikulpanit@amd.com>
 <20191104215348.GA23545@rkaganb.lan>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <070710b6-0bf4-5f6e-2352-969e077eba14@amd.com>
Date:   Mon, 11 Nov 2019 18:05:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.1
In-Reply-To: <20191104215348.GA23545@rkaganb.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0005.namprd04.prod.outlook.com
 (2603:10b6:803:21::15) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0c07b5e1-187e-4955-896c-08d76703fbbf
X-MS-TrafficTypeDiagnostic: DM6PR12MB3722:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3722ADF07976C439D9EC5530F3770@DM6PR12MB3722.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 021975AE46
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(199004)(189003)(478600001)(26005)(230700001)(99286004)(6116002)(3846002)(2486003)(52116002)(50466002)(2906002)(53546011)(6506007)(386003)(76176011)(446003)(36756003)(2616005)(11346002)(476003)(486006)(44832011)(25786009)(2501003)(47776003)(66066001)(65956001)(65806001)(14454004)(6666004)(23676004)(5660300002)(6636002)(66556008)(7736002)(8676002)(86362001)(81156014)(31686004)(6512007)(66476007)(229853002)(186003)(66946007)(2201001)(31696002)(6486002)(14444005)(110136005)(58126008)(316002)(7416002)(6436002)(81166006)(6246003)(8936002)(305945005)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3722;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iIenCPG+2foHjQUoqoNBCwwo4aPZttszjVb/Zt7HAoINPq9hdCuZN5FHBt9IOg271pqB+j0kbshGASKIyA2HE8di2RbvZc4KsuhkK80LYgXk5I8d7O1f7LoVEUH3WsMrYkEzL86ezw66Em4Clalgi4mtSFmnFpu2k7xD8AZ1kN4X0Dd0MvzSK8ncAoVkx6qQ00zsSDkMNQTg/GKWwcmTzWH/JVfcb3OeYClQNsIRme3c0SGJJzx4/r0wpZtTbuw4IIaWhaVD+/PSUzbmQMVQOIve74uYOe1QjojoO03YfM8/DEo7EjjFJ02FBlDflDkMFwNrXddPGx8/E+MHJUtlcEsowNDdnhLgoYKhqwqdEsgONFxsUVz//i4K+CwGrAIjzls1aohIJ4YJU3ewm6A1yPmuWHvIR7RlUqg084qBUZU8AplBP+jVnWHjNRpRY0ME
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c07b5e1-187e-4955-896c-08d76703fbbf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2019 00:05:10.8817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+ouvbODVFE1IEmTWvvJV690BXCTElpAjGsuyKlMhD9M8dknHRifW//BU8NsFYbdBQAweOHMtTrnzqWQK4plXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3722
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Roman,

On 11/4/19 3:53 PM, Roman Kagan wrote:
> On Fri, Nov 01, 2019 at 10:41:30PM +0000, Suthikulpanit, Suravee wrote:
>> Re-factor avic_init_access_page() to avic_update_access_page() since
>> activate/deactivate AVIC requires setting/unsetting the memory region used
>> for virtual APIC backing page (APIC_ACCESS_PAGE_PRIVATE_MEMSLOT).
>
> AFAICT the patch actually touches the (de)allocation of the APIC access
> page rather than the APIC backing page (or I'm confused in the
> nomenclature).

The APIC backing page is allocated during vcpu initialization, while
the APIC_ACCESS_PAGE_PRIVATE_MEMSLOT, is initialized per-vm, and is
used mainly for access permission control of the APIC backing page.

There is a comment in the arch/x86/kvm/svm.c:

  /**
   * Note:
   * AVIC hardware walks the nested page table to check permissions,
   * but does not use the SPA address specified in the leaf page
   * table entry since it uses address in the AVIC_BACKING_PAGE pointer
   * field of the VMCB. Therefore, we set up the
   * APIC_ACCESS_PAGE_PRIVATE_MEMSLOT (4KB) here.
   */

When deactivate APICv, we do not destroy the APIC backing page, but
we need to de-allocate the APIC_ACCESS_PAGE_PRIVATE_MEMSLOT.

Thanks,
Suravee

> Thanks,
> Roman.
> 
