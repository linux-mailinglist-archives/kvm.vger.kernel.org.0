Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89AF27C8B59
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjJMQWc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbjJMQWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:22:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4E01732
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:22:02 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39DE0pbc008991;
        Fri, 13 Oct 2023 16:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=JWvYLtCXAjcH8QTvjryeffyaujjOw7Pjg8uV/Go01Qg=;
 b=T/o9NBdorCIIqDAw1Zbgz8ILUEfvrsuDVITKtqGetLcRSjSE0NbKliKzNuqJzmKO+SAK
 n8XJRUWKubPuTAhX6uiidY0piCX2TgVmpGh7Jwqu+c5PW4t3EO7fYxaLhIj+grgtv0Zk
 aMbA4XgqwlnNWbTAECpPtyYMFZywk6btd89ChE8xDiMt1+sxcMeZrnvvT2jBQKKxmbjy
 bMoayLF22yHk1XKLGByBHLHgr5FvOOcLIaIIA+pX7LLdsdA0ZF9x+1XEnzcv2wAVfi3S
 +vsN8tCWVjKFar1IDdkBm6gjBb291PlpURMUneWsPGwbINVXPOMYZXNeStb1e8LmNwqA Yg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tjxxudcjt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:21:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39DErikG036875;
        Fri, 13 Oct 2023 16:21:27 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tpt0ukaw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Oct 2023 16:21:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mP3UiK4EnwEdTYEvjISUnHVHwZIZ8AwSgMM0/Tvv8A5fMvpaWFUPyZj9sOXrO5wgzp8ZbFpsSF94pBzwP8d83Z0T+NitzOGKdMJqLrPuLB8vRyZFwa0YhrczZTKqbOzBf/WMAGAOCpTzU72n5zazV1+8W03qd8BXGE5jjKaHNArHz9JcDj27vBGfC6Ye5OdL6aYPSx4IULP7DFFQq9CB9Wmb4gOn1YzOSLaCn6cBTW46c3S7d20C8ZOEOqae2XNXVcEfJHqYViWvYVWb8UuPnZ7FeSmxvHSiD+CtbQjD68SoJbkQQVrWF5luap1Sy+NUyh44y83QJfY/oFzEOQqu6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWvYLtCXAjcH8QTvjryeffyaujjOw7Pjg8uV/Go01Qg=;
 b=fQA1ZUpm2sTj/0Wnw6wEH4iu0LxLnH6zE5oCYuEPcqgS3BNAGsJv7GGEnL0xopErA1A0qYf5vI5ZNVmqZK2DJK24dB4Mz0XgmrDApwmgxX2meASY82thgCzViaiszV6b/dxcvLBoyuxLK4Cx3ZFnZgX3D9SYOeeTIW3KuS0aUKG25lnqtms/csJq7Ij2xdCPtRGbnZ4nsPKzAxZp3xWiXNgZKh/U0vSu1u8xFUijR7CV38l/7ORubmkrDEsYFg69rWMBRWf+6OYiDAHHPtnaj9zQLDa30ee+LdNymELGJKsYPCmsutWoqFs1WLyab0FZpk7GUNgI7iyNEX/gLtzfXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWvYLtCXAjcH8QTvjryeffyaujjOw7Pjg8uV/Go01Qg=;
 b=BK81mJ9ht3ec4hySIvMJ7WIRtzBx6QANaU9M4gBDjlPZ8DR3jKGw2+zGgrkDa4TnAjIUvLkavJUtxuehRUHRiOrp0k7FIx7RPHVB6VFuMyrSyfCl1DXOSFtnB7Ge/uC3pfz+t0XMNp56Rk2JE/LxNdLa6LP4wzhXGlh19zgOxak=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS0PR10MB7456.namprd10.prod.outlook.com (2603:10b6:8:160::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Fri, 13 Oct
 2023 16:21:25 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6863.047; Fri, 13 Oct 2023
 16:21:25 +0000
Message-ID: <465374f1-e472-4667-8e13-23ee2d60ff26@oracle.com>
Date:   Fri, 13 Oct 2023 17:21:18 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/19] iommufd/selftest: Expand mock_domain with
 dev_flags
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
 <20230923012511.10379-6-joao.m.martins@oracle.com>
 <20231013160241.GZ3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231013160241.GZ3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0021.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::34) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS0PR10MB7456:EE_
X-MS-Office365-Filtering-Correlation-Id: 78094d26-c399-4110-9451-08dbcc087209
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QEsHSvb02qnKvMBaz5LtjA7nczWVO4W3Echyw+IVYC6oprtkXUPjyaUZbaVjPoFNlEETu/fDW5AM0WDrOqvPlUpUf/6JUSXCXwPau/mzI5QRQddr6vqgGzhshcX0WCzpyA8fmX0TxTLFNFtDtRjGv+rXIgg/kvfEh9whkmYIsOijKe8FElxN/9rh01foLTiU9QWhv98FT8I4+dmNDZULjb7fZAEDKcEyraxbDKglFFScbj/vgSRqXxXqhHTAkFFFj5X6xrk16DYg1sknUz/ayOMIwr13szwZD82x0BCE5szDAqyI/u0Z4ZxcttIAYRBOp1gXvGpQPnsQB9l5iYpft7ZHdPyU4t0qAUFDtSFzBCfUCdFT4gAMZVe6/vTC1TO6ekAAkpcC0jcmTuQqjysFr3cGzY/h/C9BrUJ6CA7lL04+x2twgOay8vlY6qD0hoMIzXA5KLZTCvMFeC0amAGtr6tIBIUbUk57LShFLGJ+qGiLc+dbiA0pwLHVUuGceMTUKFDVkc9snl3JsNUJ2RJ5lT4hGObe29YZEN7NvqLwh4y30sOzSlSzxmRUZ2tazamrS6i6uobx5UAMUwaTsYP+t5c1uaSGzkuGmYXLMXcNPr+IkK8pLWmbwiHRTvAd23RuT4B/7ziU1m66Q3ZOillRRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(396003)(376002)(346002)(39860400002)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(6506007)(53546011)(83380400001)(31686004)(38100700002)(6512007)(7416002)(31696002)(4744005)(316002)(2906002)(6666004)(5660300002)(26005)(4326008)(86362001)(8936002)(8676002)(6486002)(66556008)(66476007)(36756003)(41300700001)(6916009)(66946007)(54906003)(2616005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUx6a0Q4UXdkYzN0K3ZhalUrZDhxN1UrYUt3aXNLb2pBcnhCdUgzWFBVZGlK?=
 =?utf-8?B?ekcwYThxeDF1U2ZWQURZYWtLb0UwMnlZMHJYZFZuNVFaMVZhemNEWTFicG1L?=
 =?utf-8?B?U2tFRnh1dm9SdE9ienh5NGRndVY5YlRzWldTeCtSQUx6R3E0SXFLWGhFL281?=
 =?utf-8?B?anIwa1JBeTRIeVV0RVlJcS9iVHdQbi9IZ2hIN1pObGc2MzRHaml1aCs2LzJ0?=
 =?utf-8?B?OElwQlhQelU1clQwNkdrMi9nYVZmVHlkZUljOFJPMG1EWE1YdUJxaGNkQkx5?=
 =?utf-8?B?L040aklqaXBHM1k3aHYyZ21OSkFUekxxaGIxRW4weWc5UEZZeEdqRFNUbmJs?=
 =?utf-8?B?T0d1YUxRT2s0MVJ0dlVna04vNXRuVk1NQWFTd0JTN2Y1Um1PWUVZVUp0YlZk?=
 =?utf-8?B?UzFqRWpiZkZvUjh1Y1BhTGxGWW1KWHpHVVhJV2gwZG83MW5VcEI2VmZkemxT?=
 =?utf-8?B?Q2FFRzhiMmxkUTdNdU9mTWJJMmcvdjYzSUwybUZGVDhVQ2F6Lzk5QytjZGtF?=
 =?utf-8?B?RWR5bWdOREltcEhVdFBRWmdCejFOLzJDRDVoQ0hHbjJLL3hwQysrV1NpQjAw?=
 =?utf-8?B?c0FLam81NmZnampMSS93Qi9yVGhvOHNnNFlycmQzaXAySDJNTHJRQVA4SU9J?=
 =?utf-8?B?MG8vNmpzd2VMUlBUeGlJd1JoSURSUUx5cWMxWmNTUEJVY2x2dGpGSWk0czJn?=
 =?utf-8?B?TjY1Z1BadFdYbDNLYTR1ejRib2xLMGhqNlpkOWswT2RoV3Z0d3dVY3ZtYlk3?=
 =?utf-8?B?U2xuSEw1RCtHOUxvMnc4a3NhVTZOWjVLclJNeXl5ZHQ2OWIwTjdQaW4wWnRu?=
 =?utf-8?B?VEdmS2hUQ1A4emd1MnpVaHJrUTNqN3dwWjRTNUN0c1EwYVpxRFpuVDZXWlNx?=
 =?utf-8?B?R3lVRXFQK053RVVnMktVSlkxK1FRU0cxaWxBTnBBYnVBS09TNkloczk4UWFR?=
 =?utf-8?B?dVVLWjUzd01BNDdQWnVkQnZVZzljMnc4UlBqdTBFUzBLZmhZV1lmUnRxQ0s4?=
 =?utf-8?B?bkhZalZmaysweVEyRU45VjhFa213M1NEaW92My9aa1I1UUN5clFZbGo1RC9D?=
 =?utf-8?B?RzV5N2x4TFJuNWNaRkpzQmdEUC94MWJvZjJKL3UzU0piSzNYNnRJenV2a3Bl?=
 =?utf-8?B?YXZjeGhnYUM3SUUxaHJRNmswWGZUWHRXWkltRTJ0RERzOGdSTG52UzRaRURu?=
 =?utf-8?B?WTdQaG9UWGc1UXo0enlxUk9VVk8vcFFRbUVIVG0zSE9BZUpLMVl1ckdqVEtr?=
 =?utf-8?B?SDZYWnVCdVQ3Mm8ySjRFQmxadkVXRkhaU1diV0xXQlg4Z1VGMy93UndVQ2tT?=
 =?utf-8?B?ZTFyMVJzUWRZOVo0bFYrWlpuRUdXOUZTRUFRck1RNVYxL0R1WTRmRHpsL0tk?=
 =?utf-8?B?eUlyWW9ObzNQNUFja1dwZnhDaHBOVUpMWEpvWWtXWXgwQ3k2Y3BmSmsvcGRV?=
 =?utf-8?B?TTd0RGlpT1h2SDdKUEs2UUtHVmJkRTY3U2U0NkNYNjlIQWRhNFhCcVhqVjR6?=
 =?utf-8?B?SGxJU05kdGNqMzV0and2UnZuMUtZVjZWems3RVNoSHRDSWZCYUgzVVZqMEk4?=
 =?utf-8?B?dHFjVGlDYXNEc1p4RUVXaHpjVExORElMM0JFM05GU1N6NUhKdHN1ZUhTMDVi?=
 =?utf-8?B?ZkRXRkVkdmxxRU50SnNlbnVKNEplaUliSTl4US96Z2RXbWZtekJ3bms0U0pk?=
 =?utf-8?B?aW45R0pxeWhUTDd3aFcwdVZXcG9yOGI2RGs2ZHZpR1I3bUhiNFNWM2tVenhu?=
 =?utf-8?B?WGg4cTZMZzBzVUduU294dFMzSDhQNXJTaGV1RmI2Q0NzRVRNa2NEMVVRODJp?=
 =?utf-8?B?K3VONUllY2sxbnNDM3l1N0VzVlM2d3BmMkd5Q2xaZXZYVmpiV0pEWXEzU3dv?=
 =?utf-8?B?WGRZdW5KQ2NMbWpienJmeFFPZkFidzlmTzY4Y0dWOEhBQUNhNVZKZVlobHVq?=
 =?utf-8?B?aVpSK3R1Wm5vNkR6NVkzdXR0UHZRWlRZU0YxMy8zS0lCQkRvSHUvWDF4Sy8v?=
 =?utf-8?B?cDBYYmdHaWIxNm9qSS9VYVMrRVV0SVV3V0FkVmZMdzFDRGxyMWpjQjdhUGxG?=
 =?utf-8?B?UmFjd2lSUjVnMUZUUUN4VGdiME0rRWRCM2NVU3FOd2VrRjVzWHU0L0k4Unlz?=
 =?utf-8?B?UTUreWZBUXZsdFcveENtK29Za1VrbGV4cE00UW42UWpvY0w0ZEhUSW9RY0Zy?=
 =?utf-8?B?dnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?eUtidHRnQmdKNVRnNVhuVVJYVjFkMTNkbWRMRGsrMS9vbFZrZjU0YU5NSjIr?=
 =?utf-8?B?NUlLMmo4Wko2S3BmYlgwY0Ewc24zUHA4cEovSXUwQS9KckxZOUQvZCsvV3d5?=
 =?utf-8?B?UU50c0ZyUWowUXA0bWxCQ2ZZdUkzZ045a1kydWFjUloyc1ZTaE5HcE5OcWxX?=
 =?utf-8?B?REE2R2VDVWlJYjFXcU5UN25BcWRxRWl6NXp3VCtTS2JINlJ1djhjVVNPa2Nq?=
 =?utf-8?B?TS9FbDdMaU9DRVRNTzV2VlU1dC91VXh3ZG14eVR1RGdES0NKWHh1SjF2NUo1?=
 =?utf-8?B?US9zQzZveFBjdDdyQXkzN0tDNWFQQ1NjK29DaThMRDc5TW1iVm9mVlRuWWps?=
 =?utf-8?B?TzFLeExiY2t4aWxCaG5wcEpHRStUZ1JOMk5MMk5hVmJOa0lpTUxiejZxeDlE?=
 =?utf-8?B?SUxoV0JyUUtJNFlCR01BRGIyR2VuZ09RUnYxN056a1pwSUJZOThNT0plWUt5?=
 =?utf-8?B?bkRHM1UxMFdSNnJFUS9zejZNbnhBL3FQREc0L3hKd2dldk5jY0hyeTJYRzQ0?=
 =?utf-8?B?NEtzdnp0a1hhQXdpNCsyR0NiUzVjanhsb05PN01hV0dPaEwxVVFPQUJ0VXBl?=
 =?utf-8?B?WEFMemJIQmd1SGNCQkdGcnEzS2hWV2FaSmt1VXRqUzFHTHg5eFMyV0xldFlw?=
 =?utf-8?B?d1NDY3JDVUs4bXEzWDFQUDNkUlhZR0hIbmJiU3JPSlFMcmZ5aUs4OGxPaG54?=
 =?utf-8?B?UForYlFsVkF3WWI4ZTJIOVhpUytoSDJIbFNWbUh2b0VjTlROWXZSdGN2UFJl?=
 =?utf-8?B?SEswak9jd05nR0VTdHBVR0NuYjhGeFJ1Vm5xRkVzTjNjL2lPNDJCdW02cnQ4?=
 =?utf-8?B?UHkrM2pwYzVKbHJlZi95emZjTVJ1ajlZNWhXOVdqV3lEZkRvTDY3NC8wNlYw?=
 =?utf-8?B?L1l0SDhhbHZNWUN5cXdSZlhYSllmMnFjQS9WWVhNMjUxVGV5U0ZmYURuTkVv?=
 =?utf-8?B?ODlmVFdFYzZQMFhIbFF5WFdrbnZyeWoxaDhwMkpnbUg1bGQ1anpMWjhvUnBm?=
 =?utf-8?B?dFlsRE9wenBUa2R2T0RyUUd3UnFwSFhvUVJPMGRGVHRhZWx2VWlWZDNZU1gx?=
 =?utf-8?B?Yzh0ZUdraFB0dDNtNXo1TUp2TmFQUnVmT2Y2czlaa0d5VlpXUWE3SmRnNjJo?=
 =?utf-8?B?UERjUHo3YU93OVVFa21IN3hpZVhpMVpuQXo1a3hZYlR2dzVhT05lM2c4eERS?=
 =?utf-8?B?Smx3bi8wNUFGSVpGdGU0RFh5OXlORy9oMkYwZXhzQWdmRVZxU0paT01NWnlN?=
 =?utf-8?B?eHpITm83UGlDL2lTVHV6bWJ6QjRRK2JNS0lnUkpOOU5lb0dNYXRJaExzT2Zp?=
 =?utf-8?B?UlFvbkV2OHBJWGdSV2xzZjQweTZvRDJhY1NwK0pjcXhTNzkyMVAyVXM2dWhU?=
 =?utf-8?B?eHVCQytOVklWamZHTTFwbG5ITC9ZL0V5aWVkcW9hcVVkU3VsMkdYMERzWnJ5?=
 =?utf-8?Q?DdCgp4D/?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78094d26-c399-4110-9451-08dbcc087209
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2023 16:21:24.9749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ZAeQJRP9lwVy5/GyNclHzkSWYGAIBQjf09OxuyTAbvyBMhL7Ybmvgyt70ndrPpVY5Dv7VPu3wjXslNezMMi1EhHQqMnM0xbFIfzk1ovx60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7456
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-13_07,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 mlxlogscore=863 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310130139
X-Proofpoint-GUID: eZcfhrUBD1_2e3Ku2xGiXLH9Skj0OvyH
X-Proofpoint-ORIG-GUID: eZcfhrUBD1_2e3Ku2xGiXLH9Skj0OvyH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/2023 17:02, Jason Gunthorpe wrote:
> On Sat, Sep 23, 2023 at 02:24:57AM +0100, Joao Martins wrote:
> 
>> @@ -56,6 +61,13 @@ struct iommu_test_cmd {
>>  			/* out_idev_id is the standard iommufd_bind object */
>>  			__u32 out_idev_id;
>>  		} mock_domain;
>> +		struct {
>> +			__u32 out_stdev_id;
>> +			__u32 out_hwpt_id;
>> +			__u32 out_idev_id;
>> +			/* Expand mock_domain to set mock device flags */
>> +			__u32 dev_flags;
>> +		} mock_domain_flags;
> 
> I wonder if this is really needed? Did this change make the struct
> bigger?
> 

This was addressing your earlier comment where I could be breaking ABI, by
adding dev_flags top the end of mock_domain anon struct. So figured the simplest
and less ugly to existing mock_domain flow.

I didn't explicitly checked the size of the struct exactly, but just lookign at
it there's bigger ones for sure that the mock_domain_flags I added.  e.g.
check_map with 3 u64, or access_pages
