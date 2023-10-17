Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A75D77CC9F1
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 19:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbjJQRbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 13:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbjJQRbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 13:31:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE4B95
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 10:31:04 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HGEBXc018514;
        Tue, 17 Oct 2023 17:30:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ALUC6k3Coit3up1fESdFVjIVxjW3EOTbKgqP3ArQJGo=;
 b=NFA2NCXqkpyop2Z14+//A7GJiNzZMTssN5RD3QnSGkiEGlNn0JPaoe93fCUb5a1zkjmu
 qdFk1KHAL7hCwS15hHNKa7rXLH7UhZUj/z9MCKePgOvL7/XnjPmBTaU6q8GYFlDHcLFS
 OW/yqjGFA0+Btp5MfBmTgq77q2GuaXGl+aAQaUrC1WU/hOeSf+nI1l+RtkSc1As40fwD
 nSsYXo3/DC7cuYj2U5a60xyWx8830HIfg833EOKw8tU4suXwU+ctuvJiXiC/7dTTTfsz
 fqgmYHKpgAhQQd/+ZqIMhbGeap/18CXP3cgKPBmIfCAUKdATKUVCNMdlUhmMCA0IHwex IA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqjy1drek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 17:30:33 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39HGUZ53015439;
        Tue, 17 Oct 2023 17:30:32 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg1fc9tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Oct 2023 17:30:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9a2WDnrVjyaVvKMLHeCcxZn6B7SyupJO43nE4kUzzqw/Y7ntPUAKCBaEhgJw3NjkU9XR+9NUymqJmKeeIea2nNP0dSBK56u3/8QnqchTXvtOycamOhkztBLkIUIVRnHXxxaBjRs95/46yfb9fKtUC8z9jWCKz4F06cYdHCpye3GC7eFOqaf0FY9Ubi4MqgLZeWHPU4HgB1o4q36Tmh5QBYDMiV4dN+NkM+noRjbzDtFRNxWNLp9j4lS6QkjttaBqXIfDHzK8asdNnOyut2EMO5ldPhVFPzHGJXjfmODzdrlso4QBzxJRN1sSlu5ZOvzdrGRmPcwS/RIlEUBk1Lc1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALUC6k3Coit3up1fESdFVjIVxjW3EOTbKgqP3ArQJGo=;
 b=gHSutCs2/fDT3VOMLcKU3cnXzIEsF96MspnjHiXx9C0A4NuPCuFzmDzpUCN7Jyv2O6DFjArDqqBoLuWwXSr2pz6xZPSvgK1QpUoIKgYvX18fhocEm9eVScgf/7//0sQ1BH0RdO4k6SmKlzd/I2EhHMrPB1F6kaIJxItKD2PwAxdPsG8z+NrrPAXuYUNF8XkUaJqu5Z/mYQH09VtBAgc+tbmhP0Dbo7F7NoxsN+t8OPlUkUeuAamKf5bh7JNN6wXV1R6vH9VCoEnnQOnTlirAGGjxbPuvCcfESRqm5O7YEmKf+P3ksMXOHoL8aRbop/lv1g4A6XEJfIM6vGGNEWGEIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ALUC6k3Coit3up1fESdFVjIVxjW3EOTbKgqP3ArQJGo=;
 b=0MqpxqZzO66W13H1uZ/dqLdwPfJWbUggCrVsXNeD56sYJXgR74iIEn1XdV23+62HPjqcs0clx9/3N3N6i2kiqnuQRfKCH4NWB3fvXhsrI2jeLxjghwAOLANnGja09/vmX8N181II1msT9erPMAWMYNTHj7hCvuTIy351kWI5WBc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS7PR10MB7348.namprd10.prod.outlook.com (2603:10b6:8:eb::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 17:30:30 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.038; Tue, 17 Oct 2023
 17:30:30 +0000
Message-ID: <ed81e5ae-57af-48d0-9368-b273848233c9@oracle.com>
Date:   Tue, 17 Oct 2023 18:30:23 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/19] iommufd: Dirty tracking data support
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-8-joao.m.martins@oracle.com>
 <f7487df9-4e5e-4063-a9e4-7139de63718e@oracle.com>
 <8688b543-6214-4c55-a0c6-6ecab06179c6@oracle.com>
 <20231017152924.GD3952@nvidia.com>
 <df105d06-e21b-4472-ba1e-49e79f2c0fd4@oracle.com>
 <20231017160151.GI3952@nvidia.com>
 <765e01f2-c0c5-4d6b-885a-e368e415f8f2@oracle.com>
 <20231017171343.GM3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231017171343.GM3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR01CA0176.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::45) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS7PR10MB7348:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d390160-1901-4da7-4d31-08dbcf36c1b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uA0260pc61CwvstbCgiSJwLPGdvXVoU/lMdHjtZqiK2JEzVc+JLxjhNFxxoaNWGOnN1poByGo1aVuq0tOhPjOhVzELtOBxjPEixB8TNW7DoF18BmBEWWLSyBikcpWZoN5GDWcdmAUVY0/97zKl+emQ84av75q9oIfFtjHKx4zBQzU0xs7OcLu3hHOO/FEEAYSgoVPWDSRtvt8x16VfVajizERDwMtS3inm0VE44RFOgc91RT0A7dIdBQ71T4p6KMCxXq7+GFGeubc5MlgwjRqsdB4rjXhQ6KrfWVo2ukNoTcWpG8UCqqYh0mndlS9EUeBTMXIPvTd+oCU8zeEiIJwt7ofcZATEscKO809U0JB7D9tv+Fe4BgDP6/gtH2tBjRN15vZIc4DP1F/L1dVXB0V7obMq6q3abVVkyEpfxwAucczzlmFQfh20p6Nlw9NtF76I9z46hEnpNlujpuKw+VHT1U8UT6FsT/yFS/RiZpGfg8YH+Ooh3km+XWbWY1iri/zNH2ec7gId739wrtsBlbt7h5+irrM6mpyTFFlAGVE5+2qlCCSjsL6wfiVab9sqqbFxya+djFDOlUuuK35RYG5PlPBpiCdtKL1TG9qKvOCViIWY3Ej9a20SHGvikwV2TwRhkF5nbcUoUAd0du9rziIIUPL9bKbkAcfn1J6FffSqY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(346002)(396003)(376002)(39860400002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(31686004)(53546011)(6486002)(6666004)(38100700002)(36756003)(26005)(6506007)(2906002)(54906003)(66556008)(66476007)(6916009)(316002)(2616005)(478600001)(66946007)(31696002)(4744005)(7416002)(86362001)(6512007)(41300700001)(8936002)(8676002)(5660300002)(4326008)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bG40eUs5TVFSMGljQS9uSVpsNXlhYVV0T3V5aGZXbHdJa2VScHdlTkh4SDhH?=
 =?utf-8?B?Zm1Nc0Erdm9yemtwclFlNzM0MDB0TVNUSHV2TVNreUVMcXVKS1AzWnpmcDFW?=
 =?utf-8?B?M1BUQU1MY3VkUUxPYm9HWG5kNEZnSDU2OTV4L2N1eEQyKzNIWGxpN3VKeURn?=
 =?utf-8?B?N3dlY0hIVzMvMlRIUms0WDFRMFAraDlqdTArak5FeUN3WnJQdnJCbmVNQ0xp?=
 =?utf-8?B?NjJoSy9qMlpWMkdYc0k4N1Y3L3k3RXVQaHVWNkRtbDNKeHdPTU01U1dtSkUr?=
 =?utf-8?B?VC9UVXlqVnhUSzZvVnJaWnJqeDJiNzVhbndpR21WZ1BXWDdLK2RTb1pGUzFU?=
 =?utf-8?B?QThPU2oybHNBN3lqaXEwUFJLWXF3YXU1RDMvckZHZ2pQSFJTT1FCRTZOZnRT?=
 =?utf-8?B?bmJXdEpNZWV2UklZdVpoN3hYRHpzTEZSK3VFdzlRM0xNQ3RBNVRvU1M5OHdD?=
 =?utf-8?B?VWpkVnBLNGF6cnVBdTFjZmRndDczS1dOUVFaYzBydEtPZDVPMmFSSkRIR1FQ?=
 =?utf-8?B?Ly9mbVFTMmM2UWN2azNYWE1KYlFLWmg1WnFvNGNZNnNXZHBYVDVwbG5odlQy?=
 =?utf-8?B?aG9Rck4vVWcwc0FQODdvNFJ3NHkzbW9uTlNSa3p3Y1BuQ0o2UGhCZlFwY3pt?=
 =?utf-8?B?VHBINzhua2dVWnJ4eVNmVDZ5ZjhIdGJsTGZ1K1BTbldMTndkVVJ5d2JnbVZC?=
 =?utf-8?B?VmtPREhIeHhwdGpuQldEWW9XalM0NnZvZ3BsVFNWZXl1UTJrOVpRVEVCd25m?=
 =?utf-8?B?TzhpZzhqbHNOaHIwRTBUS0d4ZUg2bVNpWldaU0NTUXhHNkFKajlpbVE3cUJx?=
 =?utf-8?B?OVhHZnZvV09nVlZpcTFxZGNiQ3ErM1Y0em1SVSsvZXVNYmRsbnlWNDlwOEFj?=
 =?utf-8?B?U0tvcGptZk80WTdTT3lUMkZZVlJaNk5pMlNpMlB0NU92eS9tNjVhRUtKUDh4?=
 =?utf-8?B?MU1PcmQ3UjhBNkJrQXdTblNDVnVGb203SDk3elZiUm5RNmxLY2psOUVjd2k3?=
 =?utf-8?B?VWlOZHdhbzJZdVY0TEc4TU1ncUNKWm9BL25tNElRK1BoSThVM2Z6ak1DREVL?=
 =?utf-8?B?VXc5SzV2U0xXMVQrb1lBWmR0ZFFldFM0U3dJQmN3MGROV01EMEVhcDJ6dTcy?=
 =?utf-8?B?bU1RbktKbzdkenVWUFRhUmdVSzNGeHQrN2ZNTjRvUGNjemVTMDRxbkdoN3ox?=
 =?utf-8?B?UGFFS21WZnNScnBER1BYWWMyVWJIZ29RUEU4ZGFxbzM1cncvUmd4ZjZTbWUx?=
 =?utf-8?B?WVVvaVFyWFEwN3E1S2hnY1Bna0dwREFvNWY3bndLeEZMZk1OandVWS9FRVpG?=
 =?utf-8?B?bXk0ZGV6ZlZOKzRvelV3amVweDlxNEhYeThPZHpvWE5PMG5hdUQ2RjJHWHRN?=
 =?utf-8?B?ZmJ6VWxoNHl0TTBrZFZuM3lEWm5RdFIyeXBZb0J0QzBWOFZmNXZLZUhTakpp?=
 =?utf-8?B?ZDFMSFJDakNLNGs1eFR6ZFFiYWE0UWxGczluSUlGNmkyeXlxc1ZLSHJYSUhy?=
 =?utf-8?B?YVFJRmovNmZJaUNEVThaRmdVQ0RqWU9YL1pjUDV0T2lOSUN3eUZ3RTVHUUxv?=
 =?utf-8?B?TUIzYlphaVkzV1VzczJhMzdONDJhZmJJTm96RnF3ZzFKMnFOYVI2bzMrU2NO?=
 =?utf-8?B?a3BZTVd2Tzl5RGJVaVBmL3lWS0t6MmZNbkp4MHd0dHhITDFzRFhjZXBmNEFR?=
 =?utf-8?B?a2VCSi9BNXZTZEpOeldZdlJ2UnlTTUw0Y3FjN3VZR3Evb2o2b0ttQkZjc0JD?=
 =?utf-8?B?VldtRittNnRzWnYvc0N0RmZaSmNqOG0yQWh5aEErd0U1L0xJZnczcXRGc2tK?=
 =?utf-8?B?VnRTQ1N4cEMzZUVtUkVPTFM1VmhtMFFNaEp2RnIxNllHN0NaY0x2SndyUzRF?=
 =?utf-8?B?bVYwbDRPMEFNaytFY2JFS05uaXJra1YwQUY0TTYyc3JWUE1DR1E2YS94eUVH?=
 =?utf-8?B?NVhYcXphakZTVGp4Rkw1TDhhMUMwUWRIbEtNanFrNXJFVW5Nb1BZMTJkYTQr?=
 =?utf-8?B?cGtSRzRuVS9UbzFtbWlnaWhLeXgzRGJqaU9xcW44bkJQVGZDclJldVViZm5X?=
 =?utf-8?B?QUxhTytEQkNrcDlYTEg2WXozOUxlM1VRTW15OGNKS3NTU1FhSVJUMit4STFU?=
 =?utf-8?B?ejk5NHlhbHE5SzEvSXdXejgzbkg1dzJHblVUYnJPYWtKWW1YV2NEZUZ0aENG?=
 =?utf-8?B?MHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?K0t5YWFRTjNnVHpHY2FzWEhXdGFOZFhtMmFkMTM1R28wWHJuRWZvdGdSaTh4?=
 =?utf-8?B?SUZ0MmN0T0tSWlJFazZkNE5PM3lGaExUTElzWUd0RUJkNGpTSk9kNzczQkU4?=
 =?utf-8?B?TFF1NFlWWmZ2SEpjVmN1VUhSTmdVSnNJUnZZQUt0aS95emdpaTJJVS9kYmVu?=
 =?utf-8?B?SW4yTTZiUEF2bEhzZkQ0RlBQRWRkd0pWUUJnTTBFQWN1TG95dys0dXUzK3g1?=
 =?utf-8?B?UmNFOVpqUUxWQVNXLzN3UjhMMm9ZWnZ5VjYrS2o1cGhZKy9qQ0VFZk4zcmxJ?=
 =?utf-8?B?TE5DaWhBR0RsMjRvVk5sNTEycGl2ZFRRYythMTN0cmNCUXhoUWVpK1FiM1ly?=
 =?utf-8?B?WE1hYXY2YVdhMmhaSTZsRFVjVGxFZ0NITDZidVN3SmVnQU5wSWREMjNpR0tV?=
 =?utf-8?B?UFhybkd0SnRtaFNWb1Z3UlhRLzJEQnQzd3QwSGRkWkhRTnI3Q0cyR0N0NXpV?=
 =?utf-8?B?eFBYaXA3cXUvdGxvL3pkankvaTV6c1dWS3RLQTNlMTVCMlFpVnJ3aHJmNzlq?=
 =?utf-8?B?M3pEMG9Qb21DNDc4ZEdTQnFSMEpOR3puQ2hXNjVCNW5LeVN3b3Z1YUJGS3h1?=
 =?utf-8?B?RFRDSjRuWEZBd01NWlBsbi9BSEVEUWJmQjNON2tIU0E3aWxaYXpyVjBLRldz?=
 =?utf-8?B?djV2TllzcDdSWEVrRGZFd015czBleElKMDZZdWtGbWlnQ3NtQ1k0dGJkUmhJ?=
 =?utf-8?B?a0lHb0dzTGV2RWJyRks2cjVzcW1wNlZha3dxc0gwSWZVQ0pGUGtVSFlrWmxj?=
 =?utf-8?B?ZVp5emZWZlkvdFdCdVlyMXJaSlJnSjBySjNGOXRtQ1FyalZialowMWh4Nm1K?=
 =?utf-8?B?Ry9oNndlcDBCODFWbTB2TGNTakVuVzRXM21HSllZOWVCZWRPM20yUVhXc2Jy?=
 =?utf-8?B?UDFHOERHSEk3dElIbjA5SGY5UDRTWUNOZ3VneklQSHpPTjRmaXpLazUwMm1T?=
 =?utf-8?B?OHE5WW40RzkxYTVNVVVLZXZvTDB0RkJwc1g1SWZZQ2RkYXRlTlRoRDIwK1FZ?=
 =?utf-8?B?dE5ldlZtUE5tZ2QyS2o2VFJoOFlhaGpZLzJ0TUt1MG1HT1F1ZGJyUEtxR29i?=
 =?utf-8?B?NmNQZUxOUkhYYzNoWEFJVHUyRjdpZmloSUZYMlBFbWlZUUhtSE5aZW5DQU1m?=
 =?utf-8?B?S3J6TE5JRC9nem8ySUZzUnBvblBEWFl3ZGhIWjlsOWRuMTBXeEMydlEzQ1JF?=
 =?utf-8?B?MHhQS1BiODNFNThQN2VSTE9aLzJPUHkxODBBZW1yU04rOGtQMTVDOTNGbWxr?=
 =?utf-8?B?blVYUjBUd3lPQnJkWnJaYXJlTFBRV29YZU9xbnNEL1dzMjBUbGpxd1lvMFFk?=
 =?utf-8?B?SkJ4akVQQ1FoRzUxdG54REtrTU93Rk1oUEI3dXZUaHJVcXpTNjM1L29nczdp?=
 =?utf-8?B?TnQ5ZlFlc3NST1ZHUm01U2llOTRnT0l6bzhlWjlmek0vZDcySHhCblhWVVFI?=
 =?utf-8?Q?XyJz5nfZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d390160-1901-4da7-4d31-08dbcf36c1b2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 17:30:30.2984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCIlOGiQ3WBbxYTW34ndL/3pf2Xw/BossBylifJVQBf5PY4kZ/BKMU9Jya5WQP1vcMQ2ToAYzt1uNm1gM+a/INRZHptm1eZNN31BbGXUODo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7348
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=797 bulkscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310170148
X-Proofpoint-GUID: 5RQ09DzMr2NnJJfhACpoMyJ15mcyu0i_
X-Proofpoint-ORIG-GUID: 5RQ09DzMr2NnJJfhACpoMyJ15mcyu0i_
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/2023 18:13, Jason Gunthorpe wrote:
> On Tue, Oct 17, 2023 at 05:51:49PM +0100, Joao Martins wrote:
>  
>> Perhaps that could be rewritten as e.g.
>>
>> 	ret = -EINVAL;
>> 	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova) {
>> 		// do iommu_read_and_clear_dirty();
>> 	}
>>
>> 	// else fail.
>>
>> Though OTOH, the places you wrote as to fail are skipped instead.
> 
> Yeah, if consolidating the areas isn't important (it probably isn't)
> then this is the better API
> 

Doing it in a single iommu_read_and_clear_dirty() saves me from manipulating the
bitmap address in an atypical way. Considering that the first bit in each u8 is
the iova we initialize the bitmap, so if I call it in multiple times in a single
IOVA range (in each individual area as I think you suggested) then I need to
align down the iova-length to the minimum granularity of the bitmap, which is an
u8 (32k).

	Joao
