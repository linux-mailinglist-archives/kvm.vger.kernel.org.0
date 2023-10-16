Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD5E7CB29E
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 20:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232302AbjJPShr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 14:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjJPShq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 14:37:46 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207FB95
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 11:37:45 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39GIEJmW011399;
        Mon, 16 Oct 2023 18:37:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=WEoduX+v7dpoNfgqv3rW0xI5ovZ3J4+ImxoTnSGePmw=;
 b=rZ1jF7tNI+ULPPn55Q4yhjdMndeJ3E4oPu3IPPPpH1omCcxyWklNnHBYoghUwZGVcIK/
 WYqRE4dr98e+QdIQhcInQ2lxiZogu8tRPAg1Ya3afCi7+HsepYmn4cnAn+O+SDP3ZDO0
 8CDbbuDpmEaW2b5blvKTaflbL0Dxt+zOQVSH36ocuPKmCbdkE0k0DyeBqgaOwZ3BPBUf
 CkrnI/UQsoenfDhA5areb0fJ9wtLAOFGWyPqUZeeW71Z0wY2+rtenyR3CX1kqKqiElJZ
 oZ0NqL+hhG3yFx0Cz1KWdJfsDtNIc8tmFAi6fKSwpg/6PRSnhNw/DUmND2DfaAatxjrP Ww== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk28khwr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 18:37:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39GIUA0j028736;
        Mon, 16 Oct 2023 18:37:24 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3trfy2j312-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Oct 2023 18:37:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4XP7jyikq87GxvASIZMSEofH5BpN9oViPjbKe/lg/lEHEIRIMusS43yeP9cPo8845nh/x0XJU/jCfvGEV4gVbRGP8Y0OIoXl0Jp6oTpxQBtZvm7/8rvYMxhI/RFfKpHL4v7TEQNlCRqDROcWxMiqQYyx9lzzdKhygkcjBUeKMtFHXKDtHJB0eAsL2VKYuiPrneBlMiXezx6/X52+9MjpQqlYVaSsXKH0i0qcDLL5LozloJ3dvvPvBCCtum1qalhFlQXiQ6WsDrAsteqiiIZE5IBWAGCslqDOv9jMGwZaxBiHNcepU3p9RovxsmgvNkeoWUmqV0mc/qlBebUEd3/lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WEoduX+v7dpoNfgqv3rW0xI5ovZ3J4+ImxoTnSGePmw=;
 b=nnQgQT01CHEC6nlmMKWEWhTABtmHmcnCwI+jhgCgs3LPGWim24UZzLa1Q62ntzyeNWyweesEtMmUJ+pAYM9A7M01yp/R+R0ONf8XgaVdtiloRvcdvKP01zsOoka5PhCvID3nVJ3eCnHBwjgJ4q8uxTGxG6po153RN4llbjB98/jE473L5sd+PbdOQ9Bq4Ti6JZ39eDJB1DYjL8+x5n02p5wu6ncTKqfixZuI/mtJKK5ilpUbK7teNEAL1wxPTRXD0FQbTYWpn/o7EgWorreXkpVwG/CJ5nnmyf6KgIGKFsNUkS0egsL6RbA7+ABMii3crS07YVo1NqbSQrlYDacDVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WEoduX+v7dpoNfgqv3rW0xI5ovZ3J4+ImxoTnSGePmw=;
 b=CtaeLaxTTnaY3WSeWD8UM6W2Z2kqK86dn2G7XtHwsc3YQCxivLDcioymr/M22dYYJjZKIR3jZa2B2VpUCbj/yGACrAw5Rx1sskYGtg+oZtbKBpiLvwWKwHKnnZlk4W7TiMWSP35+wZYkKj1M0oQK+DD+HfK76a9/6PpKpvDKRVc=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN0PR10MB4933.namprd10.prod.outlook.com (2603:10b6:408:125::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 16 Oct
 2023 18:37:22 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::64b1:cd15:65a5:8e7d%5]) with mapi id 15.20.6886.034; Mon, 16 Oct 2023
 18:37:22 +0000
Message-ID: <6cd99e9b-46d9-47ce-a5d2-d5808b38d946@oracle.com>
Date:   Mon, 16 Oct 2023 19:37:15 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
References: <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
 <20231016163457.GV3952@nvidia.com>
 <8a13a2e5-9bc1-4aeb-ad39-657ee95d5a21@oracle.com>
 <20231016180556.GW3952@nvidia.com>
 <97718661-c892-4cbf-b998-cadd393bdf47@oracle.com>
 <20231016182049.GX3952@nvidia.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20231016182049.GX3952@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0156.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BN0PR10MB4933:EE_
X-MS-Office365-Filtering-Correlation-Id: 0379a4e0-c757-4537-3529-08dbce76ef7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tTR4xg1M1ZLbIOZP+DpglFFpa6VvJhW72/315JEjNaaOAb5uvqQuwNoVEp/zoUQpPG9SXNJgGhXyx5dEUL3eawCMP8YP+1FfY40Qj0fJyGccodyd/YL1GKgtGO886lQ9Bbn7hiBelLOQgBuCPBHuuoLGgNL1DqGI3oMR191ncZZ9jYJpYghTWYlj8SMnNB1YmRJxfH1nLOJu0OhKzdXwbYL0Bbb5iCzqykoeRBFZTcPbb2L8uoCTQNc+D5PCyGngYinAAZjloUFAe+a2ooBjX1gmhsnjNQ+0Mszt5CqhFLjIk2W+gx3iVWkJwiQ2WPbH30BYQ+wvqIzsJd524No1oRcNkfA5OH22bSl9L43v+8i5nPKNiIDCRlKRp8CcsrtNo5+hav+iHmOomDJRgHBf7eD2iS/vEOgM4wgJ1IEfoD9BpVTadRMcRyr1Y0FAgqImprXcyl2r6J96DTDtICUV/yysjLKRubd0hVcodZ9ZdqByp3tSMdXecCxNC6F4s6mhs55wXn5InOxoZ7cs6QbPVau0Jd/WyFStpOXLh5VWiJw8GxfY4RPUsgs7+GSbnsIlOZ41Xd8Iz6hFNkUful4/oo7mtT3IT2v12/O47Qh1cvdwTadkmucSq/rU4567sbuFUNMbvxXQ6bOkxNoT527AgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(346002)(396003)(366004)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(6486002)(54906003)(2616005)(66476007)(53546011)(66556008)(66946007)(6916009)(316002)(6506007)(26005)(478600001)(2906002)(6512007)(5660300002)(4326008)(8936002)(8676002)(41300700001)(7416002)(4744005)(86362001)(31696002)(38100700002)(83380400001)(36756003)(6666004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnc0TUllNGdRSEoyTUtBdGtZL0dxb056SGUva29lQndzSURpVW5iWXZEbTAz?=
 =?utf-8?B?eWU0Wk91bk1GSXpVU1I0SGZ0ZVZOeHMxdWxhZ3RDTUwwZ3NOY3laZUFpZ2Fz?=
 =?utf-8?B?ZGlpeW5td3psdjV0L016SGZFK0NvZGNnQlRGWjlTQlV6aDNrY2hra1dHRHpE?=
 =?utf-8?B?OVJSb1FVYVFPa0FYQXpQV0NsZDdKVXlXa2N3STBySXVvT0ZaRFVPYks2Zm9I?=
 =?utf-8?B?VXFTQjY1cjkxWDhpVTRCUDZoL1dlWXY3b094RGF3NTZxYU1ZbUE3WmlTT29m?=
 =?utf-8?B?amRTOEhEUk5NWk1qZDIrcmlLV1diUlJ1Uld5UXZGUDNJcVFaL0wwVll3UFVy?=
 =?utf-8?B?WDhaU0lNTXY2c3JhRmJDbm9raXYwL1ZpRGVVWUp5SEhlWU9JeXEwbHFwNUxV?=
 =?utf-8?B?ZW9MWjNlOW5ac0lFOHJOV3VNd1FFQnFYM1lJSE1CdFdzTEhnWkdUaDE1amFn?=
 =?utf-8?B?VXpxeHdwUGlSYWtWdmlOblNOTDlNWVM1b1d3YVBPT0dXZmJmeXFKNE5yaGZE?=
 =?utf-8?B?U3BjZXV5NUZGdC9oK1g1aHdkbWRmZHhlNndZSTVKMlRJY2lxOG4yemJJeGRT?=
 =?utf-8?B?aTJFbVNIQzJCYXR0M0R0TEJGOHk4MjcrblpEbEo0b0xJY3dkU2xrQUdVZ2xU?=
 =?utf-8?B?QXRGVzdOTXNDOERBaVJ2QzZOOWpUdmNmZE50Y3N6OWNMQmlKNlZ4R2NoSDZI?=
 =?utf-8?B?SHdaS3BHRUJUeFBYNHBlS3dpMVlNZ01XTTRTVXBMN1hQUEVmeUI4OUQrdVNr?=
 =?utf-8?B?WWQxcFlZSlFkU3VLaStPOVVQdTFIUVI2RnFuZjk2YmEzbVdsV0dTZWdabXNX?=
 =?utf-8?B?ai82akZ4elZwUkFiUHZVZys1c0VLNVJMcUFCSmNhdDFheGwxbjlQeTBDaWtn?=
 =?utf-8?B?MjhEeE55R081U0xPejA2R0hrZXdLcWhiVjJvQXNRYTR6QW1ZanJXUEthWHRZ?=
 =?utf-8?B?UU1aNmZvZXh1ay9RRnFRNGxQWEtVNk5kOXFPVXBjMGs1ejVtMVJUNDhNYVU2?=
 =?utf-8?B?OXpqNVFhS0xIZ3NPUnp1RWxBK09nMWRwYi84bjQ5YktQODgxbWVQQi9oM1VV?=
 =?utf-8?B?bFY2UGdPUmVOR2NEeXZpdFhoNHBwR0JodE9MakxYOStJNHk4Z1ljamtUYUxK?=
 =?utf-8?B?dzR5d1VMY2xXZFJzT05OMmVTejNOZWtjL2FRRUZnZlRwbm9ubXN0TEJUUWNO?=
 =?utf-8?B?YUMrRmlnbGFRbThOTlMrM09id1BaSEdlV3BIdXV3RS94UXZGQTRKZEdqdUJZ?=
 =?utf-8?B?NVRQaXlZcG4rQSt4aWJPN1RMVVI1SDlYMG1UZldYUnFZTVRXVXlqdlAxOTIy?=
 =?utf-8?B?Y3ZnN1A4YW44cW5uMElOcExxOXpCdldvYjY3ZWYxS09sRlZqMjVVNU5CcGJZ?=
 =?utf-8?B?TVBLQ0hOYmgrT1lMNXQ5WUxRY0lHb2ozUCtWUTVKWnVkMmVyV2tkVXpCM2M3?=
 =?utf-8?B?VzVXTWt1eC90R2pJMUd2dGNST0gxeDFpVlF5NGU3bVoybXhobFlsZVBReTRl?=
 =?utf-8?B?cW5sQk1lOW5XUXltQ0IvNVRFdElldkMrR2xxSnA5azZSbC9yaXZkQjQzdzhr?=
 =?utf-8?B?eFlQdEhFNmlOZ2pCWWpOeDZSbXg3TmVxck5ESGZZQW11WmN6RFlEU08wWGNW?=
 =?utf-8?B?Vy9yR0krQWRFNExCNWhjaGhiNmswKzdSNWozUTRhRUhLRWhFTTlKdEZ5a3hN?=
 =?utf-8?B?NU4rdVBGS09LODU3TTEvdVdqencvN2pEaEcyK3dWbVNhbWFxQnB3aTdKQloz?=
 =?utf-8?B?d0Q2a2pLZHo4QUtjbS9Lc1RicEpNRkVyZk5HaU82emsxQ09ISHVkemFjVE8y?=
 =?utf-8?B?dU5rK1UzbGRPV2FHdVN3aE8xVXgzalZZVUs0eHZFNHo2V2hXWW9hU3djMUc1?=
 =?utf-8?B?eUZOSkhlQVBtK2JDRFZSNE5wNUFSc0pqNzREYkwwaFpHWWp4WmlVY0h0alZv?=
 =?utf-8?B?Z0NMb3UvSUlxQmsxdmV0ZFZrdEdmLzhoWkUwQVNqSGR3L2JUcEpLOVBOTFVV?=
 =?utf-8?B?THZqbW5XbVcyTGgyN1czbFh1Rnc5TjZQWWxhM2pnR0NTQkpsMjdCRlRSdXpu?=
 =?utf-8?B?Ty9KSi9WSXM1NUl4RjBkYXpUMlVwMURvclAxZ2hvbUZ2WTFic1Q0NXE3a29q?=
 =?utf-8?B?TEJRclFxakw3cmt4OEpUdm9mUDFuT2N6K0NxenZvWUlBdnhZb0s4Z1BlUVA0?=
 =?utf-8?B?aUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dCs3VllJZDM1R0FjamkvTSs2dWxiVjZWRG9ndm1TelBPWWdtc0JiWlZ0WFlh?=
 =?utf-8?B?Ly9mcm9lZ3hEWGtnS0F1WlRpalFxSlE3UUI4UVVTdUNoRFk1U3FmSlc2TkJK?=
 =?utf-8?B?aDhiTnBlc0ZzV1ZJbFFYQ3F3R2ZHaDJLS3RUcitlbGozdkdndWdsYjQzeXpt?=
 =?utf-8?B?MW5Ia2FNREIvcnpVbm9WMkJpU2IwaUxFSFM3VmhRNDJHejFzdlByVDlPN3Zr?=
 =?utf-8?B?STdGZDNrVmJhZmh0UFQyS0tPK0tpMXdYT1lYUXRwZ2ppclpsQlpSSFhhTFMw?=
 =?utf-8?B?UklaVk43UytGOGplOVZTQnNvektsQ0hQY05va1ZTbXpqQzZBYXQzOG5BQXg1?=
 =?utf-8?B?Y2ljZnZBa2kyZVh2NE9DK3RzYnNHRitiUGtmVXIyZWdyNU5wQnErNmE0eWY1?=
 =?utf-8?B?R3JEWFpaZ1dvNHJxbW15MlY1L3kyMDV1amRnUjNHd2xBalhhNHo1RjJqcUpw?=
 =?utf-8?B?eDd6YU0zYWRpd0kwc0hmQWVPU25RZ1VVaDQwVjZxUjA4ZU9ncFJkZlpkUmkz?=
 =?utf-8?B?TDhrdDNKWDNkVVROV0NmeTZ3emVNV2ZMOWdtLzlIalRIQXc2dzFDZjZhRkhp?=
 =?utf-8?B?RXc0WWgyS05JZlVoU0sxdnhFQnFaM3RDamFqSFh4dVRyRngreFpuS3lJRlZY?=
 =?utf-8?B?UndoZmhucnZCTVRIcUprbGFUQm14d0psODRsMGRKQVEzSzl3TXI5N0tTdnNl?=
 =?utf-8?B?RkZ4WWpWelZDRFc4L2pZZGkxa000SWZJSnhaMlpwbWpzbmhiaWRTcUZuTUI3?=
 =?utf-8?B?dXhiLy9aeVdLdUFkQ1JJYit5clZOY2wzdXRwZjloMEg3dmtoNnNRQWdpZzZO?=
 =?utf-8?B?d2FoSTN6UHZPazZIYnFrRG03WDV6djJqZEdyUXJ3Qk83WHM2eGRZOGx4UW9x?=
 =?utf-8?B?ak9rMHlrZXlPYW9oOXdWODhDKzg3eHFZQWc3b3JraXB1V1ZRemkvZXhiMUl0?=
 =?utf-8?B?WFVvUElCSlVXdDZ2dVVQbjJIQnZES2ExdGpYQlZzOG1TWkI5R1ZOVzNGSlhx?=
 =?utf-8?B?YldwQlliSGNQV1hrZDV3YVV5aFdhM1dLQzBVTWVBMk9pYWs3VDNiU1JmTVdY?=
 =?utf-8?B?aThiL210KzZ0RUd6aW4zckJTQVY1TzFsTjRZMlBoSnhFZFNHNGhsaERLN215?=
 =?utf-8?B?dmFkSTBib2hMVWpoUzJlNm1vRVhKY1lxN3Zsb092M3dKVUNsZDVzaVlYcU4x?=
 =?utf-8?B?cXJxVGpnZTRwNmdhbUVPNGt0ZXozUHgrZzdsRUw0T2dqaWFqcWhGa2NTb0g3?=
 =?utf-8?B?bklHRFhTVjZTMFdOb3p0RVE4OWJMcHBrSGZneFJjQlNaTTMvL253R3hjWE04?=
 =?utf-8?B?UkNzRXRIbUVNeHR6Y3JMS0FHenZmWGZPNG9DWHlpK2F0Z3N6N2liS3pIYmhq?=
 =?utf-8?B?NUpWbWxSMWJheHNnVHllY0laU0lWSFJHVXlYNjRKcGtlV2tQWER0Q1p3RUJZ?=
 =?utf-8?Q?zyAQlGOs?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0379a4e0-c757-4537-3529-08dbce76ef7b
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 18:37:22.4340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y89puyTvVsMEWuMiPa80PYDYfuuY/6d2QbSbjn9JQ76N719v/yCncs7L95gcnezE+lXK8ZSfgEVoFFNfjz2Y2aa5fiqQKRAV+nT/3vGmUik=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4933
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-16_10,2023-10-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310160161
X-Proofpoint-ORIG-GUID: gbGjcMP3Zwk59vMXCo7S3Yi630Ub5ATF
X-Proofpoint-GUID: gbGjcMP3Zwk59vMXCo7S3Yi630Ub5ATF
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 19:20, Jason Gunthorpe wrote:
> On Mon, Oct 16, 2023 at 07:15:10PM +0100, Joao Martins wrote:
> 
>> Here's a diff, naturally AMD/Intel kconfigs would get a select IOMMUFD_DRIVER as
>> well later in the series
> 
> It looks OK, the IS_ENABLES are probably overkill once you have
> changed the .h file, just saves a few code bytes, not sure we care?

I can remove them
