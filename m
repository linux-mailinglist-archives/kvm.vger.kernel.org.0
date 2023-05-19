Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F36A7096F0
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 13:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjESL5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 07:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjESL5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 07:57:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBD410E6
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 04:57:10 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JBiwsc023333;
        Fri, 19 May 2023 11:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=54Ig7Ulh/XNjxZRq+3SHDzZL/eZf2lXxPGQbGql19lE=;
 b=XNZx+uvzoy5cgxR4a93BWu7DVw6Hm3KC4qpf+ovTWVawWpySfg7fi0by9p8sKknMrJPr
 pLfk0HuHiWyOnjE8pyBGkfKXy2FDwOzwJ7r6CarQIRBPUdksXSAWdHUXmcrF6+0IDlrw
 GpDngYbJ8BCH1PXFOHcbbLlMbHEy9AUou1FzZGewPpD6efBUrRNlj415e5GrmwXQiVb2
 WU5d0RfT458gHfNZhUOUmEsCaW9ItUbfz/PERj/u0FKHbWA4ypcuwiOPRfutX7NYFSgT
 FqjuV1wqm4CglH4MIuegW4jIqdPK1CzHsutpf/BSVi9ariCghKbbXjNEIaeAOVGIhKTz Iw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj33v2123-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 11:56:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JAukno025017;
        Fri, 19 May 2023 11:56:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj1080mb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 11:56:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpQSH8ndanl0BRqaqFnKP5qOxVZPYasobUsFQyIEtykFp8necJGbmiYMH9mANx7uqdAUkISbUvRtJxRh5f+ps+xONeGIw4mmUx8R9caJYDiX2R9+9ORe5OX+RAR7cYdxDxBP6zzeXdgqFx8WSoBqyOZrOpGxuodLMjn9Jv9PWmpSib6GsCL9WWCLP/4cKEOntotkFcdVZWX0DKIpGDMgFSTYeDFLl6LLrU7QRlI/nk3nuearENR3pk9d3W6xvZowBle2HpTh9BnQs1uXSKq6ITpJReVRvcdQe1Ka3QUIwTAvctr3YA5mmAAEUBjcXylJC/w6GwWMOL9GLjvXMJDeXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=54Ig7Ulh/XNjxZRq+3SHDzZL/eZf2lXxPGQbGql19lE=;
 b=lELIvzfh+7ZQXwKwd8eLKMOpcG5cx+ZAewITpdxF7ULPAzfO0F1RCNxcZvEyt7OQh8ZKIrCsNZ3dXdh+fu7oAJFUb/MvnQRkyCd+9Kao+nseSiO5geYZY8/q4IX6uC5mUWXJJTxcP1SbrdCkc54i1psAi+SLEBHiY7uIcxpSNrJfZNBrY2RtQgxPDGgXjAD8OKvAZdGlEZ2gel5zP8oEcDBE5U2Rrnb0wBoJg9+chop9eksyLsfB//wOBHQMK4mRn2DsvSrWHO2pFYTt0I/4QsGiuH/K2a9QtwvqB3Cov25rkLmCF06q3qRkoKnWJTUJIe3KCLuAEKhI1LM48yAu0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54Ig7Ulh/XNjxZRq+3SHDzZL/eZf2lXxPGQbGql19lE=;
 b=svETK0W7qjOvxlehayj7QNJAHX/xsKzk1wmJNEQzc0OVszGLHfifj/022bBUW/pRNnh51WsaGgD56SXlhZjBObjnKKPNp6b5GmT8uD5cVR2Fdd1i9jf+98/jw2qWA1PegGHsfopZwHBlgMELAxy5mysPNmPGe6mJPcgFowGCOls=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by PH0PR10MB5754.namprd10.prod.outlook.com (2603:10b6:510:148::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 11:56:27 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 11:56:27 +0000
Message-ID: <29dc2b4c-691f-fe34-f198-f1fde229fdb0@oracle.com>
Date:   Fri, 19 May 2023 12:56:19 +0100
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
 <ZGdgNblpO4rE+IF4@nvidia.com>
 <424d37fc-d1a4-f56c-e034-20fb96b69c86@oracle.com>
 <ZGdipWrnZNI/C7mF@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZGdipWrnZNI/C7mF@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P251CA0014.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::19) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|PH0PR10MB5754:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f4d45f8-df7a-4670-64bc-08db586013b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lf9MWkC16CGDi3b5k+gfEopCeHR4ujGkx72V0/Ol2SRWBdgEcPVwxOVlhkxv3p5XBNGejEAepIUAdhUmAiAGp4NniyYk694goVJiYEgNkhRxiDAfVtCna03YHp587UfG2M/2YwvU7HEH530AAkd58guQWfA1Wf6RIwcB+TSojivgt+4doBOhTmVHmYDyg1Ts96/qFqUyMrQwqqONc3REnjxsH/J8cFRIfw7lEIX+BC4RJNTyaYsfufITnqYhWznFZCtHYgOL4Mq6ThtrxE+l7P0W2BB3q5mg9SoRvO1AwScHOCXsoOj+PEokZqKosPXbbfveYh/Xe7CsIzwPZnJdQU4eo6fljPsKBbhCdF0zwaYuHuHoIu00pFA8TzsR9KBldDlqICOTLlPu+v/j7bCgWau2/GRPFFULKgk/vsdW4v1VEkOjruywqZ+6qRRXbgl0STvZHTPyF49h7w/+fz+WxF8/H8RizedWJEQmFU8pZ2j/UIYjJJ8Q9p0SYIorX7AvsfiA/WVyckHOTuS4aLM6b+nfnkFSKo6QrVuCsd1V60Vc60IEOniOnfjoN9MQq+siLJe6Xo6voKxS0YQqAgugt7tIT6ZAZ/7xOYLaHYoeHsbmWXj9m9JUxwFLuNdiWPCaGRY/2XzIcvEuhxz9qwQTew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199021)(31696002)(86362001)(31686004)(8676002)(7416002)(8936002)(5660300002)(66946007)(6916009)(66556008)(2906002)(4744005)(66476007)(38100700002)(41300700001)(478600001)(54906003)(6486002)(2616005)(4326008)(316002)(186003)(26005)(6512007)(6666004)(53546011)(6506007)(36756003)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXhOSUIxbmU4WHk2NmVyMmhwZkdGcmVwTUtBRUZLdDUybG1wR2VvZ2ppMXVz?=
 =?utf-8?B?dlhHblFLOWhDNElJamtxRVpZSG94M2x2RENHM0xVVWRTUFNqWTNVdkdSWlYr?=
 =?utf-8?B?SFRLOFNtbGNsdnYyN3grcUdFWlRFaG0weU42ZVNlU1hFa2FVYUQ4S2IzOFdP?=
 =?utf-8?B?L1lLa1pySHpURUtUSDVZS1lyaHJ0dE16NXFKNzBQaUE1WDREV0pYSzFiN0hN?=
 =?utf-8?B?ZnAvMjFnc2xud3BneXp6Znpuc3NMbERNNTJvbzNLZGxjdmZ5Y1RNQnF2L3Fa?=
 =?utf-8?B?dlZnMkN1eUNYNnI5aGlTVmRhdTBlazQ3S0dVSXVQQzV3djlTZGlWWlI2VXUx?=
 =?utf-8?B?TEZSUzQ3R1ovVWRwclNOZ3MvdWlBNTc5TXhtZ0ZRUUZVZE1VejVkUVFiUklo?=
 =?utf-8?B?MTFhWDRHK1FZbFhtVEt3RDFSVGVTYkdWek8zZFV6VGhzQVBPNVVmTjA1aVlk?=
 =?utf-8?B?c2F1c0huL3E0SWxYelhxS0dYQWczYWgzVG4xRnVOOVM5dGFsZFkyUFRaY1Ix?=
 =?utf-8?B?c1c5VVZkWlJMVWZydkRpQkM3UGRGOUQwb3ZlaTJuZXEyd2FhMmpReFZYUWJu?=
 =?utf-8?B?Smd0eFJCbG44cTYyOTZiK3RwUzRWTUN4UmxwLzA0V0dtcUtVYUg5RkZpL1Ez?=
 =?utf-8?B?OGhSWlNNaDhzc2FJOTF2ZkVyd1lOeTU2cTVjWWM2U1A5UTRDUnBabC9BeW9s?=
 =?utf-8?B?ZEovUTZheEkvZC90KytxbmJFSGVXblp0YjdPWkxUMGZ4UDlqRlRkRWlpdGdm?=
 =?utf-8?B?TkI4Wjg0dW8vOXEzMEFxU0xVeExKN0c1SzAyMXE3dFBxYXMweERISXdydmI3?=
 =?utf-8?B?Ty9hOStpSzZRKzdlUU4xS29KSWhMTG5HbkJMTGVXVHRzZ1NrZzN1TWN6QnM5?=
 =?utf-8?B?d0pWWkdTa0NCMUIxem9tbTM5ekw5NFd1UStSUzdXcGsvZWwraHExR1gvMHF6?=
 =?utf-8?B?TFRHd0FPaERCakhkSTcvUzFVQm1lbXRicGl2MWx2a2F0WkcyWmRLQkQyb2w4?=
 =?utf-8?B?aEg0Ky9CbDV6RUJvc0dQbTVZbm53R2FOSUhPZzltQ1orOEJHT1RhcGxMMG5u?=
 =?utf-8?B?QWFGSzFiVG9SWFYrWUdmRlN0ZGZEOHpyMVJ0WkFsdjdPbW1zQS9FZUpCTytv?=
 =?utf-8?B?QXRub1NCSVowL25WZ1l1dHIyZ0gwV2RTQmxscEw3MVQ2aklQUkcvdXJtU0lL?=
 =?utf-8?B?RHR6d3UrNklnUFU1WFQ5czZ1KzJlME9iaWVxSndMdVV1VGNSaW9YQTBNNFJw?=
 =?utf-8?B?VHk0eEcwYk05OFFqa1ZGTE5Xazg2ZHFKTldheVFXK01YVEo2T2Z1czBjalV6?=
 =?utf-8?B?SnkyUUNJVlJNWTNwSGhIc0NYeW85ODlhaklmeC9GVUZYbmpFWkp1c3dROG94?=
 =?utf-8?B?TllvcG4xZGNGNklrNllCNkp3R2NYV1MzcHg0U1F6aTJKTWlZMHB1SzRwbkJr?=
 =?utf-8?B?THRHNlZzVGNBY2JyN3lTQnF1emM0L3R1Q1NkaE82NThKaENLTHkwenN2UDJE?=
 =?utf-8?B?MmlMWk9zdFpsc2VKRUpzVUc4OWtvdUVjVjVZcUNQR0FoZ05aWVN4eUErRG50?=
 =?utf-8?B?dWlOZzcxOGZyODNrejhkMTBTR3ErdjUzcVYwcGIweENyWGtBS3BGSlYrSEZJ?=
 =?utf-8?B?SHpMOVpCRHJQZ2J1dVNCa2hNZHVKNllVMk1QVmFZcExueUxZNE4raXN0dTU5?=
 =?utf-8?B?L0hMVU5ITmFENlcrQ2orRWhFZG5wR1NzeDNncEtRdkhaVjNQb0xIKzl2VWNn?=
 =?utf-8?B?TlNFbVc2RjJKZGY0ZXFMK2VtTjhQNWlVSHBsS0Ixc1dHNSsydFZrc2FKUVFT?=
 =?utf-8?B?QnpkZ1ZJblhIVS9YM2ZscmhTakFicmlYcmZaZUowdnJyNStWTU9RRnZFSjhH?=
 =?utf-8?B?eHJSUlZlcUhSSWkyTEZNcGhoRjhrVjRLNXp3UUNwVFFqNi9sd3Y2b3dtZHlN?=
 =?utf-8?B?VDhZS3NPNkp5M2NDWDVDZVZsZTMxcnNxRVRPc3I0Y3hOelJYRDRMaU9QQ014?=
 =?utf-8?B?aERqeURZTXZsNG54VzlGMTlaOVlMOE9pQXNNTVJyZk9KazBBRGVtVWtKZ082?=
 =?utf-8?B?Tk9SbWZXeUVCTlJFTndlVDU1WXJ4d2JxY1kzU3ZzSzI5aS8rUytubGZTZ2Zi?=
 =?utf-8?B?amx0OStyZVRVQkJBSis1UVpJa2VPZ2d4MkIrUnl6bFUwRVFwWHBna283cGcv?=
 =?utf-8?B?N0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?QXFsUGZid0VPUlhaQW5KNlg2M3NEWU83MVlRblBaV2k2bHJadGRFNDRYYzJ3?=
 =?utf-8?B?TnBmNlBHN3ZOZjIzQU51S21KK20zU2hnUVVCem5DcURQcENLN002d0FxK3ZX?=
 =?utf-8?B?UWExdnoxMmVQYVdtVVIvaHNWUXZCTmxTTmdIR1oweldkYkx6M21xVllYRmVu?=
 =?utf-8?B?ZXZlK2JBZzgwZTFoaXVBT29NaXRNNTRwMzUzbllZRUFyaE1GSlJuRHljSVNJ?=
 =?utf-8?B?eFJzM1BUM0o2TmJPTlB6ajhHQlJPUXpqWndBcm5hcC9QZFlvRndNY2tWc2tq?=
 =?utf-8?B?VFo1V2JPMERRRXFqVVBNMGk1RWJXMGQ0TmtXeDE5SUE3ZnVaWG00cWM3UExx?=
 =?utf-8?B?UndVdmZ5RU1rZHVRNGdIUVdYRk44L0J0eG9CRGRnbXZnRUQ5RmVMUk5aNDVv?=
 =?utf-8?B?eW41amlMUE04SW9Ia0JTWGJ2V0M1TmZnaDU5dW9mY056Mmgwd3FpSk5QSSs3?=
 =?utf-8?B?OFlVOWprUHM2Yjg3MU5CNGtQTnhYRkRob1NjVUxKcnhZNytTY2JRMjJaZGVj?=
 =?utf-8?B?WlFoMjlSUTdhOFY4OXFodmNGbmVYWWJFRU4zSXZuVjc4Q2VTSExmOGdzUUZF?=
 =?utf-8?B?MmdIbFdZb05vREtmNDBqcHhXSDBOUXU2b1pkNUYyeER4VFgvS01aa0FIZHVo?=
 =?utf-8?B?QzByZWk2L01kM1puVjgyWU52WTdRUjRCelJqcFcvdjM4TkNiSmNJZ2RFTEN3?=
 =?utf-8?B?YWwxU0c5ZWZNSXVKRlJTZ1JhRjJ4K1ZzN0JJekZnaS80UmJ4bkthVEI5dEZK?=
 =?utf-8?B?ZGZwT3QyUGhsekFMbVUzQ0lDSXJwZ2RyK1pROFRFQTJlZVBPd28rcnRtczJ3?=
 =?utf-8?B?WTloOTVSRW5CMzMyMExIVHpmNU1ZZFZwajBvNitRclIvZnRhZVNPS1Y0ZVUy?=
 =?utf-8?B?anhkbG45UHFWVW1oZHM2SStRMTlDVFpwUFBTaVFUYVVubG1VRXFqbmhpVldY?=
 =?utf-8?B?YXkvNFZlMGVpbS9ZODBFMHIxL0U2QTg3cmQ1YjlCeld4VlBGYlpuOUJjVU14?=
 =?utf-8?B?V05yZkx1U1FVSmJjVjhSS1gxV2xlZXhZcU4vbCtYV0JpUFBmWXhEcTBZVkhK?=
 =?utf-8?B?VEVTQlU4cnRsYlpGZkkydnI1K1YvM1EyWVNWVURRUG10ald1ZGh3dit3R3hy?=
 =?utf-8?B?eEQva21mRGxjekxQNGw3Qmwzdmg0N25va1dOWHJqVEZLYU11LzBTOXhrd0o1?=
 =?utf-8?B?TXRra2lXaW5Pem9OMVZzdXUvdU5FYVhPcngyWWhVWXVsRmIvK1FtRDBwcUxh?=
 =?utf-8?B?aC9WT09pdWVETnQ0OWpRSTRiY3dnWjI0UGRmWmFuc2FWQ1F0NnRxd3JNQklU?=
 =?utf-8?B?NGdJMWdXYkl4Q1FhU2s2Vm5OeFdLQm5lQmxrK0lDTS9VUlluNXJ2VW1QMWw0?=
 =?utf-8?B?ZVZHbTZVdE5ocjVXVFBYQ2ZLRXhkekFweGwrSllwcHZ5YkJlYjZXbG9Zc2Nz?=
 =?utf-8?B?MlhQNlFsTWdOdmhrTDNVUFh0YzVaSDRWYmVhTHF3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4d45f8-df7a-4670-64bc-08db586013b4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 11:56:27.6274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5f1FQuQfJuiUE6kFFOQXMGIP1vY/nubtwqjBznnENZ/KKwBUqJ31pDM6JxS+nZFRSUvYUKnG2SPfrflJ848xsZ1Lwb3Xrh4sOXiu2T2+vm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5754
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_08,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=817 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305190101
X-Proofpoint-GUID: GSesa5_zeJmoyJp1LadAenYbyRyOdWTy
X-Proofpoint-ORIG-GUID: GSesa5_zeJmoyJp1LadAenYbyRyOdWTy
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19/05/2023 12:51, Jason Gunthorpe wrote:
> On Fri, May 19, 2023 at 12:47:24PM +0100, Joao Martins wrote:
> 
>> In practice it is done as soon after the domain is created but I understand what
>> you mean that both should be together; I have this implemented like that as my
>> first take as a domain_alloc passed flags, but I was a little undecided because
>> we are adding another domain_alloc() op for the user-managed pagetable and after
>> having another one we would end up with 3 ways of creating iommu domain -- but
>> maybe that's not an issue
> 
> It should ride on the same user domain alloc op as some generic flags,

OK, I suppose that makes sense specially with this being tied in HWPT_ALLOC
where all this new user domain alloc does.

> there is no immediate use case to enable dirty tracking for
> non-iommufd page tables

True
