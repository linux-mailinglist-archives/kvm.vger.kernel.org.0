Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C03670989F
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 15:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjESNpB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 09:45:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjESNoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 09:44:55 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E788BB
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 06:44:53 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCjGVV008945;
        Fri, 19 May 2023 13:44:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=BweCMzzr8UbOBgn1ONcxlHUQdH/ZduB2fyUc1Sliv/8=;
 b=pfUCRu7UXKeQV44J+XxqrrNkuHEGTMBD/PyYZYX68Fy+BZ98odmDbOta1wQpSW0/fjzI
 NygY9hYrPaoY8bp9l08NXsdxiSa9PrfmFuSQCdJh637Kg/YuXymVahwDKIIIGZHs97p8
 3AHtOto3kivaEmHEx9AByNMKQ/2lJDgbCJAn6ol+vhy4r3TsJCPC/PuIEXFj81l44VMs
 khAvLPZoErZ++5uyI8KYTJ/lw3Y3A9/HXvSFXL2n2LbI8TTFjBc12N0ZkZGI26xHvo1b
 dfsBdHuGbdfeUwhAhqd+Zs0G2XoIQfoo0abARdHN5QeYvX4ZiQ76ZdNFl1Gh1I5wLGFD Ig== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmx8j50sw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 13:44:09 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JDDnbs004263;
        Fri, 19 May 2023 13:44:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qj10edt3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 13:44:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqFy4F+hcK3jExP449uQzudajMz722HcNoYZaKvJ9k/8Du+tyjq2SyHxuDu6c86uq3TLbrL4Zjc09Qv1gaM6NoQA/rs4hEA+vWS9eMynpcHFwAKpSVjAWp8DwSuJAgGW9nF/a1BvWHeVgj9diihv6QAtfn2vtDNyMRY3RmMJFE1MMQKc5Gg1aVr2DwT4UWg19HTMcfnG+eaJxmiAs7ma8Tq/JLwIyISkTxXu40lQ8jWOQieIH8fYtBvdriOQe8po4HT74SBMG5CYv3SLRdzGiQO+uPg2lcdFuwZK/3gkUaNYYF4CSJze2cHvLe3tho8LR5PJs9tHShoeNLS4fkegIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BweCMzzr8UbOBgn1ONcxlHUQdH/ZduB2fyUc1Sliv/8=;
 b=Z2Q83y2bEV0hPP1l5YpP2g3fGJpuJBv/h2XcQzUR31Ce/0PFrq5IDlABuioqyFYqNU6qV1BZGEzUEHupPxHBuCrDcrXcMiqcTkLM7ugl2dQWhiN3N6g4UNK5964/gehRDtmNzwmSd9ER8Y7YJaZwehX3fUVREqtZE8aZlQQMb8PPraYYXDeyUWn1RKEq1wZXOX3qyzHxQHptnoMufGPXNqZM1MLzGfqMvguy8wq0z3rYILx2d0gECVXZThG3WINh6u/kA9LvNdqGgS3QAiPJIYl7irXb2DZMYMo6BShAb/I2bU0Gw33KqjGtEOuhZuZ2g7/y7O2POgNfjZJOGVi7AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BweCMzzr8UbOBgn1ONcxlHUQdH/ZduB2fyUc1Sliv/8=;
 b=fsXtBbh/8ZMnFP2eEr8YEEQK6KiLPqCVELHcpCaT2Tfh5UOC8GRV5SmhlE2qXPoidcjNnin5hCDHHQQsTfTrMEeFzaSvOw9kv0qIq8qJSHdA66VkI/G6V4nWth3YOXkLuwm5PbNGbq7IeMSkVSlpJp3wLCwmA65of9Y+MeR0LQ4=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4144.namprd10.prod.outlook.com (2603:10b6:208:1d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 13:44:05 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 13:44:05 +0000
Message-ID: <857caf51-ee45-0d72-1ca4-5881bc313b8a@oracle.com>
Date:   Fri, 19 May 2023 14:43:58 +0100
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Content-Language: en-US
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, iommu@lists.linux.dev
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
 <940bbc2e-874e-8cde-c4c9-be7884c3ef57@arm.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <940bbc2e-874e-8cde-c4c9-be7884c3ef57@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0319.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:197::18) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|MN2PR10MB4144:EE_
X-MS-Office365-Filtering-Correlation-Id: 481227fa-ba64-4bb3-9cd3-08db586f1cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /jXHPLY48G2GVTT5sNLyHf4DyKx8IRb1qhV/IGg1Ic/ha9wFG7CBaPfqdDdWex5nEYvrBi+E/4a+HgUsG7mL8WZCHT/wWNdsqgxYO4mH9n5n7dT3VE1eRvE3gQ9/58uxHr0vJQpodVIy8cJa4lpGFh6R8OkPidoMeIi35+bn/3qr3Xi7NybmXO5+Qh9n/cGKF8t/qh7meGPmB+TgRg6RD9nEucrxkjfbtldeGAP13A61QQjxYtE/JrU42fnB8BcSeMqBxsqgeNQYuStuJNHlcH42adTf9A+JnU7RkxryHL8rFhChVmfzjL9yHK2jkjDaBfSdDXNRe8uC2Drl7mFQukSnQxDQPoeDFy+P//SJ0X2zJUE2OkT+iAOpxAdv/0hv/fN/rEUmql+4MRtcXZgWBC7r0buXllVqRV8wI3yNPJkTBdR2GLmOuVtZxeSiKZqjnfTQ2YNfdRw75qh13M49y1mQta+wYdc47AMgVxUws+O23wdcZ0VaMS1MlNExqDhyN43kzhptnzRaITw9cUe70l6wA7LubYsszyoTanjDq8gBJ760spKX4xaoftSiykLRp0Dus5Y8TQZRX3wbCVBJpmWdpyalIA34MYamF5Ghp2DJN23z3eXZieD4lYjBn/rtONJG/M98h9BPGJ/7UTKopg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199021)(31686004)(5660300002)(83380400001)(8676002)(8936002)(7416002)(38100700002)(41300700001)(2616005)(4326008)(316002)(26005)(186003)(6916009)(66946007)(66556008)(66476007)(31696002)(2906002)(6512007)(6506007)(86362001)(53546011)(30864003)(6666004)(6486002)(54906003)(478600001)(36756003)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHVabHA1STk3ZVBKREwxM3B1T1NWa2xCYmx2T0xSL3ArQWNOREZDcXZsazZw?=
 =?utf-8?B?aGtPdTlQNkRDTXY2NUY3LzhhV055VWsyV1lsaEc4NUFnWFk4cmM3REREQ3pT?=
 =?utf-8?B?MFB4dEFlWk9tbnMreW5ucFlvUCtoYlIyM1ZLQy85VlRsRkJvdG1XaFNObUJq?=
 =?utf-8?B?a0Nhekp6VW14dEZiR1BjdmhLK3JKcTBVWmxOSTA3ODB1R01IQkRlTTJ1QmFU?=
 =?utf-8?B?NnQ5bFdzdmdkUzNjK0FKY3BVbmNZWDlYSmZoUWRaQXgvcCtkWnBmL0RGWmU5?=
 =?utf-8?B?amhTdVh4eUJ2cnkxei85S2M2eHpDalZLUFhKQnNrRzJIYkw2S2xveTlyUkov?=
 =?utf-8?B?ek4xM0JlSmZ2RGxzekJ4VGpEWHhFcWgrblh2TWJqUEF0NUI5TTgvcDhFbDlV?=
 =?utf-8?B?MXl2VjBnL1pNZHVNR0dENnVnWkdjSVUzdTNVcW4vLzRsekhhWFJsb1NoSTVt?=
 =?utf-8?B?NjUxbWJUY25ZdFl4QjI3YVlybytpTzNyMFMrcHRRS25XaFoxUDhCb2NDTFow?=
 =?utf-8?B?RnJ1anlpakJHb0ZPVmF6R1JOSXAzWE5rMXVvL2YyNEZLZFlBWHBtclhNZUZn?=
 =?utf-8?B?ZGltUCswL0Z1V1Q3b0JYeDNWYlNWNjFLb0h6NUVjL0dNTGdmK3lsZlg3eFI1?=
 =?utf-8?B?YlhPRStSZXlySE5NSEc3R2JDNmhmekUwVFFka1BhTko4R3MwN3FvS2dvNlo3?=
 =?utf-8?B?RUFJTzZiV04rMmI4a0hKVG1nVnpSUDBxMVRDbU5ONHFRNWd3dndkQm15cEJz?=
 =?utf-8?B?YVpMeVg5VnowVmdTS0tkR0ZkQWlUNUpOYnFRSEVhQnduc24vTlNucDN6SW83?=
 =?utf-8?B?QmFzWmtzWG5PMFBzN3MrK3VCOFVYMUc0TUd2eTlXWG1NbUx3eTQzVDdidkRM?=
 =?utf-8?B?TXFzRE1vdUZQZm5DZUVNOUlrODdMdEhtcnRBUGZuWnQvYnJkYWNOTnVFMGJS?=
 =?utf-8?B?aFIzRFFLZVZzdXZGaEIra3oyZVlxRVp5SHRORjlyVkkvaElIejVtMktSQ3V0?=
 =?utf-8?B?SmRYUmhJaGFrS29oeXNxTTJkeHdUYnVBcERkTUFQSWtSNnNSZnJzNFNjZFpx?=
 =?utf-8?B?d3JYR3d3RUthOWxlNFM3VFlUZmZGbGt5TlRPTVRMa21TcEZXejhOZFZRdjEy?=
 =?utf-8?B?NXkvc2V2WWJiVUFvQ2FERUFhdFhiVnVOQzZaRkVyL1MvK3d1amttc2Zzalpo?=
 =?utf-8?B?UnA5eFVMYjlCWXNzNjFhZ3k2enVndjhIajJMYTk5L3U4OGV3SG9mVjFYenJs?=
 =?utf-8?B?VEVvZjNiZFdhUGxJTFNyQTZkMHBPMTJIOUVSTEVaZW5XOUdET2NlaGRXU29Q?=
 =?utf-8?B?N1hpS25YMkViVlB5UEh1ZTBxMFVtMWZtL1I0NVE4Sjd5N1BOZnRWSzRObS95?=
 =?utf-8?B?Qnkva1pSaUJjbURuTDVvS0VsWlRaa3o4MzdpbHRqTnRtSTh5TDgrUjF3SmNw?=
 =?utf-8?B?N0lrb0d1SGswRjZyZitPYkMrRWxhMEtvbElZWlUySjZabkI0R05DZ1dIemZq?=
 =?utf-8?B?a1lzNlBzZlpQeWFDNnJWNFdod3VwWXRGY3FrN1lVczFvUzd2RHJsN25mQmVp?=
 =?utf-8?B?NGQ4RVI5K05OLzJnRFFoM1poaXp3Znc3SlUvaEU0c3Vuajg4cGZpNEtzK0pO?=
 =?utf-8?B?THl6YWxaTjlKQXNJTGdaczl4dDNKbEMzbUpHdFJ6N1kyZXZZT1BwRE9vY1hn?=
 =?utf-8?B?dW1zVUxsMmRuNEFETFJpUkloL3RRZkpleTNNdENOQ3llVVZHa2JwcGt5Yjh1?=
 =?utf-8?B?M2JKdjljV3VLYkJhaE5jM1FHYXZvajkyZVlLNlVBVUVDOFA3dStmcVdXOGMz?=
 =?utf-8?B?YldyazMwWDVYYWF6cTBlajQvc3E3R29jS2s0ZFZMZlYvK0lkYXo4c29kRTdN?=
 =?utf-8?B?bUJDazZVVGg2K1BkaVhzb0xieXJISVpQOGlQR05vSlFPbnUyV1M4bWNjQzFp?=
 =?utf-8?B?dGoyVzB6aG9XWko1cHBHL1B2MnhuQ0dtcFd3b2gzOVltM0VKK1EyaXRvVlNX?=
 =?utf-8?B?Rm01TTEwMHFiLzVON1p0RDQyN2s2dy9vdEZINDNiajZhYXBYeXZVai9MZjZR?=
 =?utf-8?B?ak13SjB4VUJKc1dxWm8veWcxMmhHWnpZc2V2RFNFZkhHYTRwNmRPRXJ3MUxa?=
 =?utf-8?B?VHJaTnZJcEdZdkJybXdTZ1QrTVdhK1NjSHBUNHhOUmkrVXlxNWhWdzVDZzh5?=
 =?utf-8?B?UWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?U0F0UERyV3J6TTFueXFoMFliTE52R1M2cjVZSnVmdGFZeGtmYTQxZlRYZ2JO?=
 =?utf-8?B?RThST2VOWUxSRTcvaUU4UGtYWDlmeU9FS3U0SWhud0c5NEhBaFM5RjdMclFL?=
 =?utf-8?B?NytnRmFUZ3dOUXBSME43YTgzb0hTOUE1KzJuREtXYUx1TWtSZ0haT3MwYy9Q?=
 =?utf-8?B?U2k2bTlGSFkzMWM0ZG41THV3SmpJaFJlOVdtdnlFbUk2K3ZJR0ZBSlBSUjdE?=
 =?utf-8?B?NENJSWRuOXlwdk1USzdJZXJkMEtkalliUkQzTWJYSnd5RXNmcjFiQ1N6ZEwv?=
 =?utf-8?B?UWhnNTltdDVwampaTDZKTVAydDZHbHU0LzVQajBGY3ZLTktSVnoxdWUxVlVF?=
 =?utf-8?B?ZmNuaGNzUkJ2eEZLWTBCWXEwZEcvN0ZTa0tkbEFhNjFmVUZsSUc5TjUwTHNT?=
 =?utf-8?B?aXM0MitIdjJ2KzgvdFNrSlh3MjZ3ZUNYWUovMHRaYnlNcEs2TEJuakN3NXEw?=
 =?utf-8?B?ZEM1RHF5ZG9tWlZ5VzFQQVQxTTBFL3FsVTZGenJBSkFDNjF2b21EODV6dXBS?=
 =?utf-8?B?cGQ1YjBGclp6Z0xxRGtTanltajNEcGlwQVlrTXc1YlFzektxSHZ2SDlKTFpX?=
 =?utf-8?B?UXVjZnlyTzNmZllLVlNLSklKS0hRc2RFRW8yOW14NVJJUTB3SHpscjR6Vzk3?=
 =?utf-8?B?SE1uVWNEY2Z3amJEVzJ6RTEzR3QzTEY5RVMyamxjcVpueVk2SnRGNitSTzdZ?=
 =?utf-8?B?MHIrME5hM0JTTHhma1BPSllydzUvSWJ6OE1iZkdLTVg0T3kyd2I0R0hOV25q?=
 =?utf-8?B?ZHNoRDdPcktZVmZCTDc0eFNPYzMrSmJZZm85T1EwUTVMQ2ZCSlc3RmhRZGt4?=
 =?utf-8?B?RjR1YkNKSFY1cTdqODRPVEU2TGQxdmtWcWJsZGVETHJaK0dMcFZlbFlEeExC?=
 =?utf-8?B?TUhCdlFHS2pTZGFSSmljcTZwY21YcnhYRktlNDFXM0FNNFd1N2lqdkFjZXgr?=
 =?utf-8?B?R0w5ODFjNW5IcDM1RU9CUzRDdEw4STdvOTkyYmZPckZmRUNrajN4cUV4R3pS?=
 =?utf-8?B?dFF2cVgxeit3K3JIM3NuMVo1TlQ1cDFOd2ZkSzBjMWRjZGlDVFZxdjJCdjBt?=
 =?utf-8?B?SUdVcng1aVpzQVdLeFFSKzMvS0Jhb0lQMjV4YW80WWI0RzlVSTBGS2JLSmY5?=
 =?utf-8?B?b3Q3dGZ4WU0vV1BYbkp4YVdLRWQvVEdNb3VVQXYrbU5kOEVVanIxbWxzR3Zl?=
 =?utf-8?B?Tkp2TEVob2txK2NRcFVoYysxanhvdWFRa2NBR0xPVk4wb3h0bUI1UThRWUdF?=
 =?utf-8?B?Q1cxRjJubFdOTjZ3N0NacW5VMlhQN0hrN3NzUzdVdit4R0kyNEQ0eHFZbkhR?=
 =?utf-8?B?VGRCME54WktYVUdmamRCVlBaS0ZJZkxaYTR2TzFyUG4rUDR5U3pJd2NFNC9w?=
 =?utf-8?B?M2RpWjNIZkliQllpTE5NS1g4UWpMK2NZL3BuZmxsZzNSZHQzeStESmp5b05Q?=
 =?utf-8?B?aVlNdUtPcktBRXI1NWJ4SldIMFF5R2pPRXJEZzh3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 481227fa-ba64-4bb3-9cd3-08db586f1cf5
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 13:44:05.6094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EB3Gg/hYArhwOUTATm1Wq13XIq6efSGJ2WUM0g5QnfcNJxQArvWAgX+YJR+0pu6oYBAa9Q23IXsOmy/2nVtdZ5fJGo6KvvWbnMJA6ONWA5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4144
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_09,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305190116
X-Proofpoint-GUID: dRxwr6tS3pbhkYrpMOm7BvJB4Vje5-VS
X-Proofpoint-ORIG-GUID: dRxwr6tS3pbhkYrpMOm7BvJB4Vje5-VS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/05/2023 14:22, Robin Murphy wrote:
> On 2023-05-18 21:46, Joao Martins wrote:
>> Add to iommu domain operations a set of callbacks to perform dirty
>> tracking, particulary to start and stop tracking and finally to read and
>> clear the dirty data.
>>
>> Drivers are generally expected to dynamically change its translation
>> structures to toggle the tracking and flush some form of control state
>> structure that stands in the IOVA translation path. Though it's not
>> mandatory, as drivers will be enable dirty tracking at boot, and just flush
>> the IO pagetables when setting dirty tracking.  For each of the newly added
>> IOMMU core APIs:
>>
>> .supported_flags[IOMMU_DOMAIN_F_ENFORCE_DIRTY]: Introduce a set of flags
>> that enforce certain restrictions in the iommu_domain object. For dirty
>> tracking this means that when IOMMU_DOMAIN_F_ENFORCE_DIRTY is set via its
>> helper iommu_domain_set_flags(...) devices attached via attach_dev will
>> fail on devices that do *not* have dirty tracking supported. IOMMU drivers
>> that support dirty tracking should advertise this flag, while enforcing
>> that dirty tracking is supported by the device in its .attach_dev iommu op.
> 
> Eww, no. For an internal thing, just call ->capable() - I mean, you're literally
> adding this feature as one of its caps...
> 
> However I'm not sure if we even need that - domains which don't support dirty
> tracking should just not expose the ops, and thus it ought to be inherently
> obvious.
> 
OK.

> I'm guessing most of the weirdness here is implicitly working around the
> enabled-from-the-start scenario on SMMUv3:
> 
It has nothing to do with SMMUv3. This is to futureproof the case where the
IOMMU capabilities are not homogeneous, even though, it isn't the case today.

The only thing SMMUv3 that kinda comes for free in this series is clearing
dirties before setting dirty tracking, because [it is always enabled]. But that
is needed regardless of SMMUv3.

>     domain = iommu_domain_alloc(bus);
>     iommu_set_dirty_tracking(domain);
>     // arm-smmu-v3 says OK since it doesn't know that it
>     // definitely *isn't* possible, and saying no wouldn't
>     // be helpful
>     iommu_attach_group(group, domain);
>     // oops, now we see that the relevant SMMU instance isn't one
>     // which actually supports HTTU, what do we do? :(
> 
> I don't have any major objection to the general principle of flagging the domain
> to fail attach if it can't do what we promised 

This is the reason why the I had the flag (or now a domain_alloc flag)...

> , as a bodge for now, but please
> implement it privately in arm-smmu-v3 so it's easier to clean up again in future
> once until iommu_domain_alloc() gets sorted out properly to get rid of this
> awkward blind spot.
> 

But it wasn't related to smmu-v3 logic.

All it is meant is to guarantee that when we only ever have dirty tracking
supported in a single domain. And we don't want that to change throughout the
lifetime of the domain.

> Thanks,
> Robin.
> 
>> iommu_cap::IOMMU_CAP_DIRTY: new device iommu_capable value when probing for
>> capabilities of the device.
>>
>> .set_dirty_tracking(): an iommu driver is expected to change its
>> translation structures and enable dirty tracking for the devices in the
>> iommu_domain. For drivers making dirty tracking always-enabled, it should
>> just return 0.
>>
>> .read_and_clear_dirty(): an iommu driver is expected to walk the iova range
>> passed in and use iommu_dirty_bitmap_record() to record dirty info per
>> IOVA. When detecting a given IOVA is dirty it should also clear its dirty
>> state from the PTE, *unless* the flag IOMMU_DIRTY_NO_CLEAR is passed in --
>> flushing is steered from the caller of the domain_op via iotlb_gather. The
>> iommu core APIs use the same data structure in use for dirty tracking for
>> VFIO device dirty (struct iova_bitmap) abstracted by
>> iommu_dirty_bitmap_record() helper function.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>   drivers/iommu/iommu.c      | 11 +++++++
>>   include/linux/io-pgtable.h |  4 +++
>>   include/linux/iommu.h      | 67 ++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 82 insertions(+)
>>
>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>> index 2088caae5074..95acc543e8fb 100644
>> --- a/drivers/iommu/iommu.c
>> +++ b/drivers/iommu/iommu.c
>> @@ -2013,6 +2013,17 @@ struct iommu_domain *iommu_domain_alloc(const struct
>> bus_type *bus)
>>   }
>>   EXPORT_SYMBOL_GPL(iommu_domain_alloc);
>>   +int iommu_domain_set_flags(struct iommu_domain *domain,
>> +               const struct bus_type *bus, unsigned long val)
>> +{
>> +    if (!(val & bus->iommu_ops->supported_flags))
>> +        return -EINVAL;
>> +
>> +    domain->flags |= val;
>> +    return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(iommu_domain_set_flags);
>> +
>>   void iommu_domain_free(struct iommu_domain *domain)
>>   {
>>       if (domain->type == IOMMU_DOMAIN_SVA)
>> diff --git a/include/linux/io-pgtable.h b/include/linux/io-pgtable.h
>> index 1b7a44b35616..25142a0e2fc2 100644
>> --- a/include/linux/io-pgtable.h
>> +++ b/include/linux/io-pgtable.h
>> @@ -166,6 +166,10 @@ struct io_pgtable_ops {
>>                     struct iommu_iotlb_gather *gather);
>>       phys_addr_t (*iova_to_phys)(struct io_pgtable_ops *ops,
>>                       unsigned long iova);
>> +    int (*read_and_clear_dirty)(struct io_pgtable_ops *ops,
>> +                    unsigned long iova, size_t size,
>> +                    unsigned long flags,
>> +                    struct iommu_dirty_bitmap *dirty);
>>   };
>>     /**
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index 39d25645a5ab..992ea87f2f8e 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -13,6 +13,7 @@
>>   #include <linux/errno.h>
>>   #include <linux/err.h>
>>   #include <linux/of.h>
>> +#include <linux/iova_bitmap.h>
>>   #include <uapi/linux/iommu.h>
>>     #define IOMMU_READ    (1 << 0)
>> @@ -65,6 +66,11 @@ struct iommu_domain_geometry {
>>     #define __IOMMU_DOMAIN_SVA    (1U << 4)  /* Shared process address space */
>>   +/* Domain feature flags that do not define domain types */
>> +#define IOMMU_DOMAIN_F_ENFORCE_DIRTY    (1U << 6)  /* Enforce attachment of
>> +                              dirty tracking supported
>> +                              devices          */
>> +
>>   /*
>>    * This are the possible domain-types
>>    *
>> @@ -93,6 +99,7 @@ struct iommu_domain_geometry {
>>     struct iommu_domain {
>>       unsigned type;
>> +    unsigned flags;
>>       const struct iommu_domain_ops *ops;
>>       unsigned long pgsize_bitmap;    /* Bitmap of page sizes in use */
>>       struct iommu_domain_geometry geometry;
>> @@ -128,6 +135,7 @@ enum iommu_cap {
>>        * this device.
>>        */
>>       IOMMU_CAP_ENFORCE_CACHE_COHERENCY,
>> +    IOMMU_CAP_DIRTY,        /* IOMMU supports dirty tracking */
>>   };
>>     /* These are the possible reserved region types */
>> @@ -220,6 +228,17 @@ struct iommu_iotlb_gather {
>>       bool            queued;
>>   };
>>   +/**
>> + * struct iommu_dirty_bitmap - Dirty IOVA bitmap state
>> + *
>> + * @bitmap: IOVA bitmap
>> + * @gather: Range information for a pending IOTLB flush
>> + */
>> +struct iommu_dirty_bitmap {
>> +    struct iova_bitmap *bitmap;
>> +    struct iommu_iotlb_gather *gather;
>> +};
>> +
>>   /**
>>    * struct iommu_ops - iommu ops and capabilities
>>    * @capable: check capability
>> @@ -248,6 +267,7 @@ struct iommu_iotlb_gather {
>>    *                    pasid, so that any DMA transactions with this pasid
>>    *                    will be blocked by the hardware.
>>    * @pgsize_bitmap: bitmap of all possible supported page sizes
>> + * @flags: All non domain type supported features
>>    * @owner: Driver module providing these ops
>>    */
>>   struct iommu_ops {
>> @@ -281,6 +301,7 @@ struct iommu_ops {
>>         const struct iommu_domain_ops *default_domain_ops;
>>       unsigned long pgsize_bitmap;
>> +    unsigned long supported_flags;
>>       struct module *owner;
>>   };
>>   @@ -316,6 +337,11 @@ struct iommu_ops {
>>    * @enable_nesting: Enable nesting
>>    * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
>>    * @free: Release the domain after use.
>> + * @set_dirty_tracking: Enable or Disable dirty tracking on the iommu domain
>> + * @read_and_clear_dirty: Walk IOMMU page tables for dirtied PTEs marshalled
>> + *                        into a bitmap, with a bit represented as a page.
>> + *                        Reads the dirty PTE bits and clears it from IO
>> + *                        pagetables.
>>    */
>>   struct iommu_domain_ops {
>>       int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
>> @@ -348,6 +374,12 @@ struct iommu_domain_ops {
>>                     unsigned long quirks);
>>         void (*free)(struct iommu_domain *domain);
>> +
>> +    int (*set_dirty_tracking)(struct iommu_domain *domain, bool enabled);
>> +    int (*read_and_clear_dirty)(struct iommu_domain *domain,
>> +                    unsigned long iova, size_t size,
>> +                    unsigned long flags,
>> +                    struct iommu_dirty_bitmap *dirty);
>>   };
>>     /**
>> @@ -461,6 +493,9 @@ extern bool iommu_present(const struct bus_type *bus);
>>   extern bool device_iommu_capable(struct device *dev, enum iommu_cap cap);
>>   extern bool iommu_group_has_isolated_msi(struct iommu_group *group);
>>   extern struct iommu_domain *iommu_domain_alloc(const struct bus_type *bus);
>> +extern int iommu_domain_set_flags(struct iommu_domain *domain,
>> +                  const struct bus_type *bus,
>> +                  unsigned long flags);
>>   extern void iommu_domain_free(struct iommu_domain *domain);
>>   extern int iommu_attach_device(struct iommu_domain *domain,
>>                      struct device *dev);
>> @@ -627,6 +662,28 @@ static inline bool iommu_iotlb_gather_queued(struct
>> iommu_iotlb_gather *gather)
>>       return gather && gather->queued;
>>   }
>>   +static inline void iommu_dirty_bitmap_init(struct iommu_dirty_bitmap *dirty,
>> +                       struct iova_bitmap *bitmap,
>> +                       struct iommu_iotlb_gather *gather)
>> +{
>> +    if (gather)
>> +        iommu_iotlb_gather_init(gather);
>> +
>> +    dirty->bitmap = bitmap;
>> +    dirty->gather = gather;
>> +}
>> +
>> +static inline void
>> +iommu_dirty_bitmap_record(struct iommu_dirty_bitmap *dirty, unsigned long iova,
>> +              unsigned long length)
>> +{
>> +    if (dirty->bitmap)
>> +        iova_bitmap_set(dirty->bitmap, iova, length);
>> +
>> +    if (dirty->gather)
>> +        iommu_iotlb_gather_add_range(dirty->gather, iova, length);
>> +}
>> +
>>   /* PCI device grouping function */
>>   extern struct iommu_group *pci_device_group(struct device *dev);
>>   /* Generic device grouping function */
>> @@ -657,6 +714,9 @@ struct iommu_fwspec {
>>   /* ATS is supported */
>>   #define IOMMU_FWSPEC_PCI_RC_ATS            (1 << 0)
>>   +/* Read but do not clear any dirty bits */
>> +#define IOMMU_DIRTY_NO_CLEAR            (1 << 0)
>> +
>>   /**
>>    * struct iommu_sva - handle to a device-mm bond
>>    */
>> @@ -755,6 +815,13 @@ static inline struct iommu_domain
>> *iommu_domain_alloc(const struct bus_type *bus
>>       return NULL;
>>   }
>>   +static inline int iommu_domain_set_flags(struct iommu_domain *domain,
>> +                     const struct bus_type *bus,
>> +                     unsigned long flags)
>> +{
>> +    return -ENODEV;
>> +}
>> +
>>   static inline void iommu_domain_free(struct iommu_domain *domain)
>>   {
>>   }
