Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76D97CDD55
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 15:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344680AbjJRNcW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 09:32:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344679AbjJRNcU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 09:32:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7534109
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 06:32:18 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39ICwv71006514;
        Wed, 18 Oct 2023 13:31:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=SMGXZOzMwgU11HH5GaTwFdT+HQ6GXnY7Zs5anNWM3Kk=;
 b=4MPN9T65ctsM4aryBong54M1UKMNU3K5hJR/Om05eiwGBPWj+Ch8AcJ2sbvkjqwUOrpa
 EEgP7NzSXmH1zx3QMiUY0wPvco/rsbUKDNzxzNIOPJP5c+XQ0KgOTTcDOMe+eYFsQHNz
 x69O/3xHtk+mY/6RuHlT6KlyQt02gOHaUETFNYUYQ7LqkCRsvYwEKNlTbzhCXnCc9LHL
 QtEwGANwqG059r/tf/CtIOe+bStvVti07rZqYm5nH3duLusPXg6rckgEqnyZkhwhWrz6
 FUFqLSUPJTQpP1wbhsbgFqQP0jCx/JeWQNAdOCH7KSWv0YdM4oRZBAFlm2eAXoXZrUi8 Eg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cfnmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 13:31:51 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39ICWU6u027137;
        Wed, 18 Oct 2023 13:31:50 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trg55a5w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Oct 2023 13:31:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gv/Ub/P6Va+KCa3wsr8YRj0HgQhu2PcPFvqTxp/0KSwexShd7avvVjqQ93QLCUBfPuAVqeUQLQ8iSIco1x4iq7SLEiuBDocS28ASadr8N+yWf6ZoujO50Y6yVmfoRix4ksCEi/iDIP73ScGE2ILXVyM1njpZm18htV0rFa77oDRRl29rekmdbQqdd8Sr7UKR88yn9iefLShy60Kpjx2IRNmwg/HuclLGgbQXipLj6b0jAAUZNFD427ktMkMhM5h7aaTH6anW2FRR++1Kqfn7gOoY4QY1OAlJkR4DV0X0PjbXsX0/zGAyskfACpyySLlhYlczJlSecmyZwz4az2O4Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMGXZOzMwgU11HH5GaTwFdT+HQ6GXnY7Zs5anNWM3Kk=;
 b=F9pua7TSVxx3kPTqENayaylyXJZpiZnDmh7O4+4P3vQbmfBUUu34TW+MM+1iyF6gxMEKO0vu3aLWqNby9E0bzgrf6d8MyNK8zkFyvXIk70b7Tw7Ipl1EpLsXv4NspBvj/AUDpNFifKLhW1Zttjoi0e7lDLaUfCo/WVmPecWmNwkWrctclTmiCHX+pv67MYnpWsV9yMj2r7aTYGtUUWBnh7JFfAP+gUAZcYX+GTw7kBxdI09KKxvynmrycLQIgqjys4+hilHO4CJVJFGMSrA/C+WqQE8G7HYhAKpbdu+DAUjm0XJor+wa16r3MvWpuhC4TZ8hcbxEq5Mdpo3Iv79pUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMGXZOzMwgU11HH5GaTwFdT+HQ6GXnY7Zs5anNWM3Kk=;
 b=fpol8Qn9jW/Ydz3EOERgcmfl63wbcA7Os8b0LqyjqxcwoortMAxKhkO6mYHcihHX9DXLD6K3y9PERRowImReaTnbPhSHnXw5DkovZglbp+InogCJ+aIgagO53o3+fa433fH/8w5gxgpQlDpTVVGXawp7OYe4SuNz59bz2y7iGOY=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS7PR10MB5118.namprd10.prod.outlook.com (2603:10b6:5:3b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 13:31:47 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6907.022; Wed, 18 Oct 2023
 13:31:47 +0000
Message-ID: <b8bbe253-335f-4836-b35e-68283b1644bb@oracle.com>
Date:   Wed, 18 Oct 2023 14:31:42 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 17/19] iommu/amd: Access/Dirty bit support in IOPTEs
Content-Language: en-US
From:   Joao Martins <joao.m.martins@oracle.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-18-joao.m.martins@oracle.com>
 <e6730de4-aac6-72e8-7f6a-f20bb9e4f026@amd.com>
 <37ba5a6d-b0e7-44d2-ab4b-22e97b24e5b8@oracle.com>
 <14cc91b4-6087-369b-c6e8-5414143985c6@amd.com>
 <8ad231da-9662-40da-a418-fc3856652c1a@oracle.com>
In-Reply-To: <8ad231da-9662-40da-a418-fc3856652c1a@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM8P190CA0030.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::35) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS7PR10MB5118:EE_
X-MS-Office365-Filtering-Correlation-Id: 2131119a-891d-4ce1-0892-08dbcfde93af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 36hN4uGqXrTYqYdOlDHGFKUgiwudftXtiaOcABv/oZaan+/F3bPtvYc1GUoU0F3DWPLVRBFXavSB2V3JZ4lFfWHKbloCSNtyoFrMkQSMmVq8kVED62q+14H0YsI8DxQZmDegoR6FHOFagpz8pOFKOHkLSTk+i+eTIYD12zaSuyBAJ85QAH33Q8dhRf1YPQY84evsKF/nvuyKWpR5GwEQb6ShBA/71gtco0YhEf0TTAt8ADQ35X8x41m9ISmwsIzOCWmibh46f8X/utl6mInC+I8OTHwUkzOjYhTsuBN5Vk6G8ZBHFouuYrAYPgtbefZfpEaPBBVEVYkii5xJ2TSyWLn8vpE9MSsdqRhhn3u7FFegvhG++ecG2YmV/Fkch65JX5I0a7ubkk25R0Fmvba/3ubr7PriEQIRy/bHbtM4+cHnRYf5Ybke5m06rNMpQ+rM3wHOcHl+KLMcAFdXX8vItXMgjGHiEnGsAZ4YDvvg2pmqMmK8DmxMm8PT5lNK8RalybsUR+qeKWzrynBczlEfZQKep8AxiCNuW8JcEZhDZlBKk1vbYlTsA8bgC4Y4t29YOd6IJA6JxTZooZLycZoNwgMgPmcaOYMhdl1AdIb+sgOHFs+PsZEELxBPFyN450HgvI+Ayc9Fg7mdSMGvQGBRdMe3cvNzti8u1mKsHVDKQAM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(366004)(376002)(136003)(346002)(230922051799003)(1800799009)(64100799003)(451199024)(186009)(66946007)(66556008)(66476007)(54906003)(6666004)(6486002)(478600001)(6506007)(53546011)(2616005)(316002)(6512007)(86362001)(26005)(8936002)(7416002)(5660300002)(8676002)(4326008)(2906002)(41300700001)(36756003)(31696002)(38100700002)(31686004)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEFQSk5JbW82VGM1dGdSeHVPNkxCWlFQeVlUOXUrMnhaQkJjMkQ5YkZnWkFT?=
 =?utf-8?B?bVREbWJxRGtSSm9FSlVxSUpaUEl5bUtzbGo5bHprQmlta21mSWpmR3FnNzI5?=
 =?utf-8?B?ZFd4ZjZDV2lvdnZDWjVPWGZheVRYczVxNVBMM1NSODRLTzNaOUF0VSs2YjVU?=
 =?utf-8?B?cVRKMlNtV3NrWW5PZnNPZzhOSTEzUHlGWXNuMjREWGtUV0MxS3JFMWhWdXFI?=
 =?utf-8?B?V2tBOVhtZGQvRTBrZEVUYWoxL2UxaHA2UFlwMnlVQmJYQk42RjBqUEtXczZY?=
 =?utf-8?B?Z3o2dU1QMkRSMjBtcytpRmpqTTRSeUlQTlFYR21KOHIzQW5kN0dhaDlMc3Ur?=
 =?utf-8?B?amcvRi9tZmJaQlV0YVMxSUVIR2JEcC9BNWQvY0VzLzEzcFlYZTRlblhpa3ky?=
 =?utf-8?B?TkYvRGZGVThmNStjUHlaejE3aHJKZzQweERNc044KzJVUVJUc2NDb05memN2?=
 =?utf-8?B?Ukg4Zk5iendueXRMZDRnTGprQjNLOW1sb0VIRnMxbVBsTG5xL1daSFdwalhK?=
 =?utf-8?B?QzFjUlJMeFRPcTNZVEtlNUI3REpnMGY3d3Q2WllpcGRORERJVjZrM1RDZlZY?=
 =?utf-8?B?ZE80TjBlOWFMNE1Od0x5OStpQW1jUUhRRkROZy9RU3hja0p6WnVlSWVHc2Js?=
 =?utf-8?B?akl2dWFaZHlQcGhlMHFGK3RvTE42S0xqUitiZUhPQUhGMFFZTElMQ1pyQWQ1?=
 =?utf-8?B?YkNDYmtxZFk3ODVJRkIyTUd0d3pBeXU4RWNueXJmajB6K1dlVFpMa3o1dzN4?=
 =?utf-8?B?SFdxSjd2SXNjQkhodlBRRUtYYzUxS0dIT1dIYXBMQ05relpmM3ZvNE80RVpH?=
 =?utf-8?B?K2h0a1VERmkvelhseU5zWWJEM01BN0NCSkZ1RlBRZG9ab1JCbndxSTl5TkNW?=
 =?utf-8?B?a2NDTVB0dTBURWFlR0dmZEl0OE93bk5qWHdEU09CQUd3ZzhIaWFhSVYwRkJD?=
 =?utf-8?B?YkQyckFBb0pnN2xqRUpRMDZickI5NGVwamhWODd2b3hMeFVZQVc5dks4RHBZ?=
 =?utf-8?B?WDhOOVNXeDNVMFhXQkRJd1pFUEZ5ak1JOWgrUVd0d3cyaHdkbjRFM0hQZGhU?=
 =?utf-8?B?SkhDRWJNcERoT255bm1rMi9QQ0ovZG1PQ0NqNFlWbGd3VmRYUFNDTnRSYUpm?=
 =?utf-8?B?cE9qMllxNUZRS2JyRW1PL2dpMFdjanR0UEFqTEJkWDczcFFwTzFJaEhSeC8r?=
 =?utf-8?B?NWpib0I5eWkxMG9kTUxqNHRuSXVSWWZaS3RBOGdGcHZGS0tUOEs1ekcrQWpi?=
 =?utf-8?B?YjdFQmFpSGVNZFk2S1g4cjZ0Y3dPSTBVZmp1NFBsU1hPNGNoc0NaN3dobWhn?=
 =?utf-8?B?WjdBVU9yT2ZBL3ZkTlNxTk5jbmlkUml6eUV6eGxOZVBrZFJsYVZyUmIzdmJZ?=
 =?utf-8?B?b0QvR3JRaHgzQW9zRTU1K0VjMVhnc0c2cW5aaFVtQzVGWlllZFQzOUFZQXA2?=
 =?utf-8?B?TFA5djN0ZERSSlgvNEpRcTBzVFVUYitVTGlXdkVxOXEyWmdDcDNBcmRLdENE?=
 =?utf-8?B?Qy9GbVIwWlVlb0hMT1dFdWIzR0pZZ1lDQm5ZMHZ2R3JGa0NYS1hWSmlTVTNQ?=
 =?utf-8?B?YlBwd0Ruc0RMeitzTDRRTFdIUWhHcUU1THF4OFYrV2FvYlRXU2NKTC9BWDJV?=
 =?utf-8?B?NzJ6VEtpTVB6NThOMWtHaE5aR2hNeGpTaG1HN3FmM3BaRDFxRlZ3OEZxTU51?=
 =?utf-8?B?ODNDV0NUQnRlVnZKa2RidzhCWUhqSDZabjJrTEVtWXAxSVd2UlduSlNLNjQr?=
 =?utf-8?B?WVBjZmY4eEV1UmtFS1lLOXhUYWJRd0pOUDh0WmtBSG5hTFR5RDZyUTF1Yjc0?=
 =?utf-8?B?MS90Q3ZxeWVMYUl5VEJUK0tmYUNqRkI4M2VMQmFWRG54aDI4SURlMFRYSzJi?=
 =?utf-8?B?R096R1Y3eFM1aTlHd09WQ0kvWlIyVVFYMTRmZDN0VHErNjhmaHFxbmtrSUFt?=
 =?utf-8?B?LzlrbFE5YkU1VURKZG56NWdzN29tcHhYd013ek1zUzNIV0RUaHBkTFlFMzlR?=
 =?utf-8?B?bElDYUllNm9EV28yZWtlSE11cFpMUzFFbmwvbm42VU9hSWhPbERhci9qY2hU?=
 =?utf-8?B?RTBQOU9tNDAxRXBjUXovM2NidnowWUpDbGpFaVRkeCtsQUw5WU01UzJaTWo4?=
 =?utf-8?B?T0pVYmRHYkluQVZQQThCYU4zOEZ1TkxIT3JETTFvQW5rRlA2SlVpeVdyaHls?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?blVwWnZzSjIrSzQ4QnBkQzU1QjJHM3kvTmtVL2ZlSm5tWXBncHkrUUpHS2Z1?=
 =?utf-8?B?WGI5N28zQk03ejBueU96RWxpYkVhK3c5Mm56R20xY0JNb25XT1M4dUFRQWdB?=
 =?utf-8?B?anFNYlhibmowYUg3RWcyazdicjF6cWhqSDIrblR3SU8ySk1IWGhiRHMrbFNl?=
 =?utf-8?B?aytRQTNqbUtxUUhUMWFPT3lTUFBQSjczWUNpb1J5dFRxVXhLdXI3N2hXZEFW?=
 =?utf-8?B?cGh1cTAzZlFVSG8ySW4rc1oxOENkcE44NGc5dDd2YnpUNWNNM1VoYkFDcDY1?=
 =?utf-8?B?QUtsb1ZLa3FVdWxYaHZXMFpRM3N3VVhFN2M1TUR0T0VYWlVneGVrT0xvSnNm?=
 =?utf-8?B?Rk5seXd5VXRmRmRTVmhJZXZvVVFuMUV3aG5HNG04T1ZXaVNzYkFYSHZmeUJn?=
 =?utf-8?B?UUYzSU9nVHVBZHVYeTAyU25ZRklzZ1Y3Q1ZpdEdLZFd6TktHaHVlSUZrcDhm?=
 =?utf-8?B?Z0NqR2d6MmxXaXZ5eFhSOU5kU3JwL2crNlhEL295aUZ3MytEb1NHNkpUbWRS?=
 =?utf-8?B?SDB6czVJR2w1WStJRTZWMk9aUkhVZ1FOSGpSaHJFVThMT2cxcno2bWQ2Q2oz?=
 =?utf-8?B?blFBS25YUUVTd1pIODBBS1hrUkh4N0wrcmRJdnBuQ0hVakhFckI2UW03VWRm?=
 =?utf-8?B?cTJDSW51Rit6SmYxeGdpWXh3OGhhYThOWlZMVGExY1pIc25zSDR2MHdDRitR?=
 =?utf-8?B?UnZKbXJIOWxzRnhOTmZWbmNPL0F2dFZnVzE3aWdCSURmc0Nyak00RitJcUNk?=
 =?utf-8?B?Si8xVnZzbGJvT3hLL3dBRy9mUllOSVByeHZKV1ZLT2x6MmJvaThhM1E1QUZ5?=
 =?utf-8?B?bW95S1c3RGNmelh0ZytUTEdGZDBuWjVldDFPOXVRR2lXNlpCZE00VGJzdzRi?=
 =?utf-8?B?bXZndFRwaGh3OC9jRmhwcjBkb3pabnN0NnpsYlRER2EwVHF5T3NpeGpGZ3I0?=
 =?utf-8?B?U1VtNDVMeTltUEV3VEVCc2o1SndDRFNpUVJjYXVnYmhqd2Z3ZjEvVjFRekVB?=
 =?utf-8?B?WGx5ZVMxYmE1VXNNUHVWQXg0WVdZMytSdXFKMEtMMEtqZ3FoT1hJbHlYQUlZ?=
 =?utf-8?B?cU94S3JQYldKSUpqekNiYlpzRUFyQnBQajZIWElCWUgwVzAvRGlDUUYvY0Rm?=
 =?utf-8?B?QjVpdDdNajBSU3NhTDN5VWVuV3VqQU5iRnFxT0poK3NrTmtOMS9CUDdyeGpt?=
 =?utf-8?B?Q093MjZkb0QvN1hPNHNWSXRhVm9DUjRuaHhrdjZTYi84OE00MGZlSk5hVm9W?=
 =?utf-8?B?RjZreWVReXNFMUJ0Q29PT2dtcTg5dXNEOHJ5Z2VGQ25qa08vbmVRdGhIQUwx?=
 =?utf-8?B?eHJBWTEzK2RRTG90MXlzOWlaTnI0c0dtbWQ5cXgzdHJrV2pub1pHQkJ2YkNI?=
 =?utf-8?B?Q3k5Ym5hSjk5cWo5Rlpxd2NDTW5SdzdURWtRU1l5bG55WGxieUczaU04Ynhy?=
 =?utf-8?Q?QTaFSUHa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2131119a-891d-4ce1-0892-08dbcfde93af
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 13:31:47.2631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0AB8aYC5itZ49SIu23dTjslwDc2xufJn4qL64451neoUXB2gw1s0mZAWHn8sbkmP15WxGtAOIAffr8j6B3ZD2IBIhvlnnq/FGxXkbn4lWU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5118
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_12,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310180112
X-Proofpoint-ORIG-GUID: __BYByMx5xEOAbGRF8NtUnErz4Odq95_
X-Proofpoint-GUID: __BYByMx5xEOAbGRF8NtUnErz4Odq95_
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/2023 14:17, Joao Martins wrote:
> On 18/10/2023 14:04, Suthikulpanit, Suravee wrote:
>> On 10/17/2023 4:54 PM, Joao Martins wrote:
>> @@ -2252,6 +2268,9 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
>>          return 0;
>>
>>      dev_data->defer_attach = false;
>> +    if (dom->dirty_ops && iommu &&
>> +        !(iommu->features & FEATURE_HDSUP))
>> +        return -EINVAL;
>>
>> which means dev_A and dev_B cannot be in the same VFIO domain.
>>
> Correct; and that's by design.
> 
>> In this case, since we can prevent devices on IOMMUs w/ different EFR[HDSUP] bit
>> to share the same domain, it should be safe to support dirty tracking on such
>> system, and it makes sense to just check the per-IOMMU EFR value (i.e.
>> iommu->features). If we decide to keep this, we probably should put comment in
>> the code to describe this.
> 
> OK, I'll leave a comment, but note that this isn't an odd case, we are supposed
> to enforce dirty tracking on the iommu domain, and then nack any non-supported
> IOMMUs such taht only devices with dirty-tracking supported IOMMUs are present.
> But the well-behaved userspace app will also check accordingly if the capability
> is there in the IOMMU.
> 
FWIW, I added this comment:

@@ -2254,6 +2270,13 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,

        dev_data->defer_attach = false;

+       /*
+        * Restrict to devices with compatible IOMMU hardware support
+        * when enforcement of dirty tracking is enabled.
+        */

> Btw, I understand that this is not the case for current AMD systems where
> everything is homogeneous. We can simplify this with check_feature() afterwards,
> but the fact that the spec doesn't prevent it makes me wonder too :)
