Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8670A7CF47F
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 11:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345115AbjJSJ4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 05:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345060AbjJSJ4j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 05:56:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DC4B8
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 02:56:37 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39J7NqU2024237;
        Thu, 19 Oct 2023 09:56:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=7NDQdC2A/5tlZs05zUHlJ+XHmRmTv3OYy03vkGW2uNY=;
 b=s5uYCcLCL+Hj3USttjg4mUXgTqk7qNEBxfCMk6NaAfKN6JeHMM/PSa3xedNHXT5F3dTD
 6DPyxTUAx+iyQ4G6P7MpefjjLNk/aIOeoy/XolZ21lGV3e+m/rU1XlaVcze8KuTy6JN9
 70EOd3KuCWvqaCZ1jcbUNhwIKwyXHM3qEphPPKl4bblmIHb6kLSkruEWoTBUID8t75BS
 gqOJvTzvUpXgEanSyHMvVIBK/pXW4ibyr4nk0QPfvnKnYrs6vnY44IACvIsGZemWrqV4
 fHKKGkhZ3QAVbyzZ8QGUrQHbOssIBgeHEj7bAlJzVYUY6/msT0RBSeqajebS6HTcZmCI oA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1d27t4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 09:56:07 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39J9b3h9027152;
        Thu, 19 Oct 2023 09:56:07 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg56hjyj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 09:56:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuLWBh2rdYcir5/yxMSK/n5LD1S+hn1IJlA0y4eKr3mp13B6SysViSApvCQ/K2z7bv86iA2VWme21zGjYCpTf1sQnLU21JGCaIY2v3mHCz/ShamqSwwm0ykHhz4pFbP6031kwZc4D/Bfsprhm49glVne5Nh0FLoyOgKeAQs7sNUC3KJUmD6u532gntEKZkVqwXLKRR6F9r2NBZ9WWQVBsZDoHz2+ZoIHAsaVfVDTWt2K8jUPc+UpaWDkGXBAmvytbSrM821K/gnAS6kTdxuE9NmurywTV+0Ilwd2+TBCqmnlJgjL0ZCABmSdrRys4VP7pna0Z+75WmxGzzOn9oKygw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7NDQdC2A/5tlZs05zUHlJ+XHmRmTv3OYy03vkGW2uNY=;
 b=O8euUOkn7VzTVwhaJpVLxtCYk07U9/ADCxRi6VDSP53EbEiWRt2Y0bpyEYRNWEIAdWM4y+oOJO0QH2bADvufYSN4D4zWz/YBTEpK80TagT1e6P7jYh2mp1KpVwfsNyQw1/tu3yFd6Q6jNCy2PQtjc9xye+zDVKG/g0SiYsxjpk1H3E+vFx2ArhadPXJVCsVwzC3r+RT0qdDUg23OX34eoF0ALhs+WRWesGoVXgm5QnG814gHbFML2nIL0pybxbfbEYK1UKgIz8wQePBlGhuHFkODdjJ5FrQUh4x9QlqXSbJuOxhkccSlv+afpQfrtTokdyvwZstg2Q682BJmrQTaHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7NDQdC2A/5tlZs05zUHlJ+XHmRmTv3OYy03vkGW2uNY=;
 b=P3sxC7+M3Vn9eEkkYVGY4HCsX6zliOysKzd5gy3DwCSkNG8RJaz4As3wP4ZsSQ4p1+50bVhkOc7p39gdgOWq0nthbSur0vsqKDm8JQq2ZjLhiytoRV/fj9uEkL3+flstSc77GC7+ZZOfkP7PcQFqBSPfP8AgoJgytqVpA6KDwdg=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA1PR10MB6220.namprd10.prod.outlook.com (2603:10b6:208:3a3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Thu, 19 Oct
 2023 09:56:04 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.025; Thu, 19 Oct 2023
 09:56:04 +0000
Message-ID: <2eaf1e9f-0c12-4306-9aab-2a63fb5b1079@oracle.com>
Date:   Thu, 19 Oct 2023 10:55:57 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/18] iommufd: Add capabilities to IOMMU_GET_HW_INFO
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
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-9-joao.m.martins@oracle.com>
 <20231018224458.GM3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231018224458.GM3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0266.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::8) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA1PR10MB6220:EE_
X-MS-Office365-Filtering-Correlation-Id: acf3e009-f00d-4083-8b2d-08dbd0899b73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OikjxcgiZD3gluroCk5spdbSVQZlw5a3NkkTu/4FO4sAEQHcQI1PWrLqiU7uOyS6X+mXsQiXFdAUiNKwB4bmUhJ7OVtCV05ErA4btiR6DmCwsIgCmSqM07uY6u4B5VSXEbRkFwsNSFqfMNDs6FMSnWhQxqRRYOqebPXuGWU0GQPT4iBbQofoSS4zFel3VuArLddmhaJG9E7oBb8U+vjPGiiRDN6bMcedDrdO4fP2F9RTqgRC40D3cOlZYzpHynsO/kp5SbyTbStt+RDk3i6atedCnWXCeqzrWHr9EJQ29VnMEbnM2fZ0ySGm0Xu4ELxpNRsE7ZVcc2GpqeqjruIZTIPNYn38vZkztF4Nc0xIgecbzYC57fZQJTXj7GLXrYn44gWhFktTk8fvo2pCxIvvbUgE07M7ppUatAlNxn8L1Mav9nEOThn/qN5vz/nvxY8hH81bKSSGHArWLVY5kB4KF/1zn8qI8pRXMrler8VxfI9VdgB+fc/vdtktGxrQ8zavqtpNo7I47XOxSn6Md4F6yu8l7Aq/nfHRSl9vYnDR25lD3q9bEyWSCS2bvdObHOEzVtecCWhREIgDO/Nv9zbxTXLKBUoxZX/y4BZQ24xSZx9TVX1a0/ABDg7BBWThSbTP5DXq+2eszZxYjgdq4o69Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(346002)(376002)(396003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(86362001)(41300700001)(7416002)(53546011)(5660300002)(8676002)(8936002)(36756003)(38100700002)(31686004)(31696002)(2906002)(6916009)(54906003)(66556008)(66476007)(26005)(316002)(4326008)(6512007)(66946007)(2616005)(6666004)(6486002)(478600001)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUQ2UGVFUkk0Mm1sRkVuYXlkUEFkajdFSXVTaHBOd0s3WFFNNlFrbWtRL0tJ?=
 =?utf-8?B?MWpmYnpNd3lJR2QvT3NCT3BiMHgyWkZvNGk2Uk1lZ2h5ZDZSNUF0bmE4MlBC?=
 =?utf-8?B?aFRmZjk4cSt6c3A4VkViWW1EWWZZbmRGQlVPTFR0QlhITE5zYS9Ga2hHZDVJ?=
 =?utf-8?B?VEs2K2pPZklRTmRKT2hHa0tuejhMcDdKMHdJcXV6d2oxMEtIS1A5Q1hBUTVn?=
 =?utf-8?B?Mi90bWFuNnFTVktJUnpKd3ZLTERQYlZqTmtxSHJFSUVEenpIc2IzcFN6NlBa?=
 =?utf-8?B?UVg3aHArTS9USjM0dWF5STY0RzhKb1FSdWZwcUxIQ21VczJIMkdaditoU0pp?=
 =?utf-8?B?aEVBVlpybE1TWXdhUE5aMmsyaGpSMzdCazZPaFdHdGY1aWV5NDhYYzVOOWNk?=
 =?utf-8?B?MnhpK1hJY0pkSGhQdFpGVENnb1JGMHdMUjR4a3hJYStST3hEelhKVVU0SXY2?=
 =?utf-8?B?aEVLdGdzaUx6eDBjdE9hYTFYWXNTUkEzalRWY3d0V0FEcEJkeVAzTUxISmtW?=
 =?utf-8?B?WlllMGp5RnNnVHAzVHluQno0VUttTnhoV0JlSEJ5Mk1na2R2YlFlM3UzT0NS?=
 =?utf-8?B?VFcvc0N5dStRWkt0ZHR5alE4ZXYrYzVuTm5pZ3F1cTdwRlp3WDhOaE1JdVB4?=
 =?utf-8?B?OC9EYm1BK1Q0NVVuTmkwUzd0ZXFsdDFyU293STVFTU5CWEl4ekpESjFxdG1k?=
 =?utf-8?B?Z1RsMnlTSmZ0MFlWM3NWaVJqVytoK0w1b25DM3c1OHNkQjJpYUN1bkw0dUpn?=
 =?utf-8?B?RlN3Z08wMFo2UzJEM3pmcWJLblZQRW82OVhwdU05bm5oRkExSzlOMzcrVlJy?=
 =?utf-8?B?OWhMM3l3eDBUbERGSmhoYW9Lck42T001ZXpENFRidEN4cjdzemltUFNaUzV4?=
 =?utf-8?B?Qmx0WVRYSGp5NERJbVNKYTBQeUZ5SHl2MXlKNkNHRC9DNXB4UVBwSE5wWkVC?=
 =?utf-8?B?MkRkSHg3Z0ZlUzhXaVVpK2VGaTMxRG15b09DSTliMzg1MWtPZDEzamFZWHdR?=
 =?utf-8?B?YW11NFdsb1lPTUpmRzVTMVVjRXZWQnczcXBKejBLd1RGc1pLOTF4NWdkc2JE?=
 =?utf-8?B?OTRKR2s0QkpySys2aGNzdTA0bm5saEVpRTBPRUVBQ21jalBGWGRnZFQ2cUFN?=
 =?utf-8?B?aW94ZFRHTWszQ041L0JMckRmaXFiMkUvODUzTXlOOVlGamNQZEdhRitwalpT?=
 =?utf-8?B?REVnVTFJNm1iclpwWEJPNGx4dlR2amwzME1jcWRZcGE5OTlCVFFld1RaNGRh?=
 =?utf-8?B?Z1FGS1prb2RCUGNOTUxieDRVRGZCTkcrU2JaYW5hMDcraGZ4TVZ1RXhFTFJ0?=
 =?utf-8?B?SWRxUVlJcVpONVVTMHRFbkRwMkxCa3FFMHlMeDNZUUpIaTZyY1QvZkdTL090?=
 =?utf-8?B?WE1TYVNCTGhKRjdJZFhCdmNOVEFxa3FxRS9VdHp5TGJZeDJsUGlMRnFIbC90?=
 =?utf-8?B?eVREcmE0aU5wcUVaZVBlLzk2VlZJU08vM1lPUXFTaEh1S1ZPM3RXK2Z6ZUhM?=
 =?utf-8?B?UDl5MDJTTTJjVFQzektvN3F6YllVaEFDdzR1bk5xdlBzVG5WR3g3TUFyOEZu?=
 =?utf-8?B?SXAva0ZKNzdpVm9McDIzMm1kNEtXS3NHdGhVd3VrMXR6YTNTOE5kNTMyWm1K?=
 =?utf-8?B?VDh1eEk3NkhDYkUyN1lGdGp4R0RYMkY4ei8xdFgrMFh3TEw0RmdSZS8wYlkw?=
 =?utf-8?B?TE82RS9zQksrcEJKNjVZMDZvcGtCZDhiRlA5T2ZOOGhob01Odmk1dWdha05x?=
 =?utf-8?B?cE4valkyZjVNMlpOKzlVU0p0VndUNk8wcUhBNFRyM2lzc05oMnBzUGtpdWw3?=
 =?utf-8?B?UytGdHU2ZCtTN0trUTd5eFZCdHJqeUZZYTVXTEFxdzN4TDdxTmw4U0hNM0Qw?=
 =?utf-8?B?cFdMazMwSDFVbHZ4WUdIUUY5Z1ZmRTF5NzRaaFkyckQ4MWJuS29GdzhXWWJq?=
 =?utf-8?B?ank1WVcrZzRTTlh0TWV2aTFyNW9tTXBTc3Rydm44R2Ivdjc4cmpCY1hoc05k?=
 =?utf-8?B?ZUpOemhSbU5BOG5YZ3JEKy9HblpoYk10azcra2RTWkpZbWZ0V0ZXcUxpUmZU?=
 =?utf-8?B?THRybmtOSGk0WWZQMzVkL1ZKbkd3OXQrd3lGZXd1NldFck84MGZpZXhJd3Bo?=
 =?utf-8?B?MGFPLzdOeVdkUDRrQitUYmFiN05ZRHNOWmxFbmRGb0RHZVdPOVBMQ2lXY2p4?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MFlEQUwyUng5Q1ZWbW1PTkFYK05IVmlQdEVyc0ZiYjVGNWdMMWtUdGVtbFV5?=
 =?utf-8?B?cG10TFRJazcvajg3MVE2elU3TXRPYVFEYWdlSkVxYWQ2bFBDWENVdXg2Rm40?=
 =?utf-8?B?ck1ZR2l5ZjFQL1RSKzFXT0JoM2MyMGV5bm40YndNcVE5WEV3OEE3NVNBa1Zr?=
 =?utf-8?B?M1VHcGllbnJsemFiWVBJRkhyajkvT3FHcGovWDRoNnFiK21XREsvMHNvellu?=
 =?utf-8?B?WWxsMWV2YlFpSFBxekFhUGRmSGFaOGhEeUJST2lGRGM1Q05waFh3RExaRFhB?=
 =?utf-8?B?dE5tSEd2ejhKMjdLWGM1WnZnZGFGY0JhWnpkbUF1ZmRzS2pVYUtleUNUNnZn?=
 =?utf-8?B?MnZ3MzF1eXAzOHpwUWlqR3lNTzFWUjdIdldGMXkvS0VkNGFyTzR1TFhzVjIr?=
 =?utf-8?B?eFlWV0pEenZxQTdCN21Ndk1jZDNkR2g3VlE1Nk5zd2F4cUUyRk04czFZcjZn?=
 =?utf-8?B?OVpEVFdUNk5CVno0TjBOcUt3M0grWVlvR0FvZzU2cW9wem1WQlg3ZE85SlAw?=
 =?utf-8?B?MFpFMUtNT0pIWm1aSWJKRTZyY3RFTk50UFl6Um1xeVR3MGoxT1Ira1p5TTc1?=
 =?utf-8?B?TmZRMGR0aEtYMk11dXZSakZOZVdnc21haDVSelVPclpXdlBFejlQcjJqRmlQ?=
 =?utf-8?B?b2dDLzJsL1B4ZWpiZGdPb1VCcnpSMWFQVkNmK1BEeDk3bUFsdHBGZUJNT0FM?=
 =?utf-8?B?ZmhHR1d2bk51MWlXRDVJcjcvSmpjaFljWURzYWlBYzErNTZnTTdXR3o3WThF?=
 =?utf-8?B?dnduVzQ1S2ViUWMxZEFUODVOK0lCcEZoT3grOFJaenFWS2RXajBTdWpBY2Ju?=
 =?utf-8?B?b0JMQ2JtN2ZKcnpzY2xQZ3dMWHFkbGd3T09YbEI4a2R3ck4vcW5iN0k0SEFI?=
 =?utf-8?B?MkdMb0RZSVZ5K1lvSzNVaGNoSGZpNEhaWG1QM1R0T1pKckRtU0VPYmxMVURM?=
 =?utf-8?B?NUVoalNjZXVDS1pZcVNGM1lPdXpTZkZ6WEFPQUJQZG9halY4RlBmZHVRUlZS?=
 =?utf-8?B?R0R6d1BVM1U3eFFzRm81L2xVdkxzSEpvS0IyemJWaCtPRzk0VzFtbDVxbWYv?=
 =?utf-8?B?S0ljbTZxYkpQbDFidVNxb2d6ZC9hdzZvT2t4S2pRSFROWlJaVThsKy8zQThv?=
 =?utf-8?B?RG9OYk5LNExabTZJamdTZ1FlbXVmZlltWFNBWHY0NnUwZTNuWTUzU0pwOVBq?=
 =?utf-8?B?ZHJSSmZXdnJzL3NNek5tOWcrWHRhcVFRVXBGc1lnSlFta0FMNVJWczVNRmJj?=
 =?utf-8?B?TTBLZ1dzTmNHakNkL2tqVzRBZFhVSmgvbXg0Q291L2oyWUlRd2djZVZDaVYz?=
 =?utf-8?B?d2duc2p2M1JNd3FGN29obEg0OEd5eWdBT0tXT3JBcnlKWm1wdHFhNHlSNUZ2?=
 =?utf-8?B?MmY0aEQwcWhQWU5tSkdjNmtBeVQ3d1NqeFY0aHBNL3VvREhtcmVkeHMvQTg3?=
 =?utf-8?Q?7kXsIE7O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acf3e009-f00d-4083-8b2d-08dbd0899b73
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 09:56:04.2547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DIcQyRSlIrQFEsVmcgvqMJPPLNm3dNUoX4/yhwUuAystohDvBRXHMVH+0g+cS1g6Wk708rgPQCy2LvwRWBY2ZB86x9+ZCUceDi0etUACbo8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6220
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_07,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310190083
X-Proofpoint-GUID: GR4m8ECHlD1woNyvmySL83knlSOT2GHn
X-Proofpoint-ORIG-GUID: GR4m8ECHlD1woNyvmySL83knlSOT2GHn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 23:44, Jason Gunthorpe wrote:
> On Wed, Oct 18, 2023 at 09:27:05PM +0100, Joao Martins wrote:
>> Extend IOMMUFD_CMD_GET_HW_INFO op to query generic iommu capabilities for a
>> given device.
>>
>> Capabilities are IOMMU agnostic and use device_iommu_capable() API passing
>> one of the IOMMU_CAP_*. Enumerate IOMMU_CAP_DIRTY for now in the
>> out_capabilities field returned back to userspace.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/iommu/iommufd/device.c |  4 ++++
>>  include/uapi/linux/iommufd.h   | 11 +++++++++++
>>  2 files changed, 15 insertions(+)
>>
>> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
>> index e88fa73a45e6..71ee22dc1a85 100644
>> --- a/drivers/iommu/iommufd/device.c
>> +++ b/drivers/iommu/iommufd/device.c
>> @@ -1185,6 +1185,10 @@ int iommufd_get_hw_info(struct iommufd_ucmd *ucmd)
>>  	 */
>>  	cmd->data_len = data_len;
>>  
>> +	cmd->out_capabilities = 0;
>> +	if (device_iommu_capable(idev->dev, IOMMU_CAP_DIRTY))
>> +		cmd->out_capabilities |= IOMMU_HW_CAP_DIRTY_TRACKING;
>> +
>>  	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
>>  out_free:
>>  	kfree(data);
>> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
>> index efeb12c1aaeb..91de0043e73f 100644
>> --- a/include/uapi/linux/iommufd.h
>> +++ b/include/uapi/linux/iommufd.h
>> @@ -419,6 +419,14 @@ enum iommu_hw_info_type {
>>  	IOMMU_HW_INFO_TYPE_INTEL_VTD,
>>  };
>>   
>> +/**
>> + * enum iommufd_hw_info_capabilities
>> + * @IOMMU_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
>> + */
> 
> Lets write more details here, which iommufd APIs does this flag mean
> work.
> 

I added this below. It is relatively brief as I expect people to read what each
of the API do. Unless I should be expanding in length here?

diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index ef8a1243eb57..43ed2f208503 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -422,6 +422,12 @@ enum iommu_hw_info_type {
 /**
  * enum iommufd_hw_info_capabilities
  * @IOMMU_CAP_DIRTY_TRACKING: IOMMU hardware support for dirty tracking
+ *                            If available, it means the following APIs
+ *                            are supported:
+ *
+ *                                   IOMMU_HWPT_GET_DIRTY_IOVA
+ *                                   IOMMU_HWPT_SET_DIRTY
+ *
  */
 enum iommufd_hw_capabilities {
        IOMMU_HW_CAP_DIRTY_TRACKING = 1 << 0,
