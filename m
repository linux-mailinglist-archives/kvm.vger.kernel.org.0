Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811755FC7D5
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 16:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbiJLO4i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 10:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJLO4g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 10:56:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71A0AD9AD
        for <kvm@vger.kernel.org>; Wed, 12 Oct 2022 07:56:35 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CE3oZC013110;
        Wed, 12 Oct 2022 14:56:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=wOpQR4Cof96CCbC9ZlLyn+MpJQlGCd2vFRFnPAWz/3o=;
 b=wBEyYZ98LdkA+XT4CyrSOMngTUwGQdckhvC20JzyYEurCu+RcLgY9pkSdS3i+PoU9HJX
 aiOzER0A/7ssGxhpjUKZ534eLZ8gRc6JPdMIR0w2Aik2UVTcjAcBTb/pLfThuwtPYZsq
 fFz+lmEJFd5R/O9r69mgtRrk3uifSwMag3C5umWGiM2FDHOFOIJRuzcc+WsI4f3CnLQa
 rbkJ1RN4lpA2SUomPn2BK0KkPbnc6NhIIh1Ve6RFbuYG9Z/TkPl+s9B5vXQNZwFGTfoT
 0SBT8L6AQpPl3rIeQkgs1mOXkJ+XlVxGLSV2Kqb4+r9LaIjtypGVEDkEigAuKJwjq7s8 jQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k2yt1jbnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 14:56:04 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29CD4EkO002893;
        Wed, 12 Oct 2022 14:56:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k2yn4pgpt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Oct 2022 14:56:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7r/hM5MsDmRSHpLN4ooIftVvmVJYJTuJvibGc2trtXgu+Ur1HTYAYFid234qsQ3MriVZNBdaRBca/5LoCkFpduyzOdML8MfLiE6rhrEoGfhEQTZO6QxdUG6Gv7nI14T6wET1er1HlqAjnWu/k5HbimFq2a0dzB/QydXVsDoZub+cJoSINSDjS0NE13z/9XqcM/L3A/yN1jVPKlu0dxZ5VxWnzxPwLWgmP2COVS0W6F7WW6Q1qvf1uCP77mOL+z6y5NNp2nf8YGBA36aKTUXwGV1Ug06teG1lNF8AFIM5nXE1vWdw5VHp7QiyJcHO/aEREQs/8NNMKKwkvb7GzpDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wOpQR4Cof96CCbC9ZlLyn+MpJQlGCd2vFRFnPAWz/3o=;
 b=hWCiS+5hZFHw+BxMdsQ6GMJ9KV421ZG8KSaD4z2TthZUlU05ALsJ1MzXVJLVvmJKpm+0HIpybi6++XK6j66L4Gl3LOrh1f6JS3WdoMcg0NyWI5S+gX4sosIcFZQbvx8kMheRH/aBIZRuaKbtOECqX56IM0VXffegUvWddC4YMSUE8pMR4YUo3jSLMCa/s1NSDziNyOVOyHB17UioeOrVMVHwno/MUeNjLnmtQdRtfSHvx8MeGtCZuipC/zqa2I9NtTthHA4aayJfmZ4x0my22zkwD9uJAu4oZvzPP/JDcLAsnfC2R5EXumwjnGL+J0+dd/uK1i2rnsoscN31uYDMdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wOpQR4Cof96CCbC9ZlLyn+MpJQlGCd2vFRFnPAWz/3o=;
 b=JIKrFyx7s599izqMp2++Qf4dxtmQfp7iT9z3CMRUbgUOHwn2D+DmLa4MJDKWHzUWrUbaNgofmupZ6IOKqpQUpefPDYfs3nkmNu1zHLpj5BIM9t71jjtdvB0TQESIjcd9UGsmeNCI2pidBGWkDQB9OcfeZYEgctLMHMy01BN3gn0=
Received: from BYAPR10MB3240.namprd10.prod.outlook.com (2603:10b6:a03:155::17)
 by CY5PR10MB6072.namprd10.prod.outlook.com (2603:10b6:930:38::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 14:56:01 +0000
Received: from BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::8cbc:1639:7698:1528]) by BYAPR10MB3240.namprd10.prod.outlook.com
 ([fe80::8cbc:1639:7698:1528%4]) with mapi id 15.20.5709.015; Wed, 12 Oct 2022
 14:56:01 +0000
Message-ID: <f9ebaf3c-acb6-b260-6b97-872d52568bac@oracle.com>
Date:   Wed, 12 Oct 2022 10:55:57 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH RFC v2 00/13] IOMMUFD Generic interface
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Rodel, Jorg" <jroedel@suse.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Laine Stump <laine@redhat.com>
References: <20220921120649.5d2ff778.alex.williamson@redhat.com>
 <YytbiCx3CxCnP6fr@nvidia.com>
 <2be93527-d71f-9370-2a68-fac0215d4cd4@oracle.com>
 <YyuZwnksf70lj84L@nvidia.com> <Yz777bJZjTyLrHEQ@nvidia.com>
 <0745238e-a006-0f9c-a7f2-f120e4df3530@oracle.com>
 <Y0Vh868qUQPazQlr@nvidia.com>
 <634a8f2f-a025-6c74-7e5f-f3d99448dd4a@oracle.com>
 <Y0az8pNrA9jOA79k@nvidia.com>
 <f9e6ea0b-ebd9-151e-4cf6-6b208476f863@oracle.com>
 <Y0bR+lJ9Li2E/hfJ@nvidia.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y0bR+lJ9Li2E/hfJ@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0063.namprd03.prod.outlook.com
 (2603:10b6:208:329::8) To BYAPR10MB3240.namprd10.prod.outlook.com
 (2603:10b6:a03:155::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB3240:EE_|CY5PR10MB6072:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fc589a0-1c81-4939-5535-08daac61e11e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CowHhM/F9LFFsFSYoGaIDmEeLT8NpVEzZdQnQ1eyg1dS0VDliMOvuHa/BxMjWJubmMgdkGEMHNwZgGNO1adZwtiFKeRtWFrYzhTPHX67VuS1vhmoLunWbOgM+Y6DuaXtLcQt0nk9Dlx8JpTUkhI9vQ5MZl1dFmDMVaj75CJZt/6rgl8S1a5r18E/7DqePZbKBB/1XQ2fS2kI5ARFUW9NiaIgZgHkOxTo5YL2P/OJM3MpQlk3/3DoWszyS8hTTZM5ybN7UBEYGRBeuuYVMymRsSsrDWRCcYnn0JScqo8izR8MsW2d3M1B2V87UAmlqkqCWmo0g0BDS3Vcc765JHwy24U7YU0D0sGFD3wtM3insmMKwEsXU0TtP2ITTS3grd2JWrMPqPt8rxgeEcYNCU7Qjh1vbR/dBSXJtII6MnCuhuZKT9jYlPxjxS7mnA8BTGtm+RiSsgkD5DSFI1iNdXKgqPsJG57Xujx53KXszi3xA/9HUVDtOutSpnphZ6xvgoJKNOXXyZq1MNJax+hecdYcYQMog4Osa5s6KUMgkmZVp3JH4fmV0zk7bbiiBjGNPEqjZ2u1Jrx+ueYNSuzSk0bY8bTjWWYNZUPoaoQiEubHnYQC6uVPHM0mLBV2v2zHG34f8QsVHSB3jL1Mfoth4Team4MTQZ9jSWBRXJHSTuk4wU9tbE0VguHoZYPkDtYp3wazNGmvROdlG9JuQGUZagQF8Q3egifKO2YZlS25jTiT+sgQ3lIKpN/7csxsIv9PEwCYVy6d24ZN5O14c5V+SG0TeVkNNX+iKyKwRjx/gcOkiBlZlTLeUes6YZkamEw29Hq7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3240.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199015)(31686004)(36916002)(316002)(478600001)(6486002)(66946007)(4326008)(54906003)(53546011)(6512007)(6506007)(6916009)(26005)(8676002)(6666004)(41300700001)(8936002)(5660300002)(7416002)(186003)(83380400001)(2616005)(66556008)(2906002)(66476007)(44832011)(36756003)(38100700002)(86362001)(31696002)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUhnTDdGaWYyZnkraURENnd1U1B2R01LNWY1NjVMN1gvRy9WYmlYOVVHOC9K?=
 =?utf-8?B?TzNVNXk3WWFnYnI0RTJVLzdjWldXOSs2Z0xzSEFOV3QzUlNWWFJldzNKZnBi?=
 =?utf-8?B?WE1sQjc3QzB1cHBoK0dTT3M5WHV4RHAzWEdzSGtxVjJYVjJuSW5SdTRDUGl1?=
 =?utf-8?B?eXRIbzVWZVlWZWNZZHd4bTVYRVZVYWd1Q0M3WG41MGl1YlhhUUJReis3dzNU?=
 =?utf-8?B?S1ZoeHJqa0JMSFJjSXpFM1orQnNzYW1hcElTQnZyRnFtRmFGanlwamcybHhv?=
 =?utf-8?B?WTRYSHhEZjMxUW1obFhGVFgzZ2NjcVlHbHlUcjgxckFoblFSUFhwUVBHQTBo?=
 =?utf-8?B?SGpTV1FHd2syTUFXdWNPd3o0NTFhWWRPQVQvYk8vZzlBY0NkM0d1cjBRWXFm?=
 =?utf-8?B?cFF5ZmZxU2M0aHVqayt6QndidDRPVm1iK0xLRW10SUtObVFReTYreWl3bFZC?=
 =?utf-8?B?V25oQml6K0hOekhaMXNTMHlKUTVDSE9RMlRoOStOS2xSQlJrZHp5ek1sV1NZ?=
 =?utf-8?B?SERlcklnSm1pYTd2b0dZcTlnUjJ1azdzWXVRSEM0SHRmbUtybjV0cnk4bVJN?=
 =?utf-8?B?YmtHWGZBQVV4SS9uMGJyNWRWN05KTHpKcVJteWd6TGpMb1Z5UWlVQlAwS2ts?=
 =?utf-8?B?azV2K3FPMlRXM2kxZ2NhN2wxOXF1SUNycVpEOElOeHNQN2ZFMytFSUJVNTBj?=
 =?utf-8?B?cUpSditNbDN3WGlEN3YwSUtXQnFRU3BoMitmNytjRmo0ektVc1lRbFNXS0Q4?=
 =?utf-8?B?ZGt3STM0MkJKLzJzODhmSTFzNDhRSVFzMkxteDQ2TzBBSGV2UER6UDdyMmt1?=
 =?utf-8?B?UVZreE5nT3J4UmE2VzBOKy9JQ1E5dlF1THBoL1R6Q2kvL2VrVFUveW1DRWhH?=
 =?utf-8?B?R1Z6YjlQMmxteDVSQ0cvbXZnR3hBNGVXYlNNQW1mRG1VTEpzODdzK0o2TS9a?=
 =?utf-8?B?MlNvSGFxMlFSMFM5WVhXeSt0VXI5Q25zbUw4bk44NDVma2hMRHN3WHdMWGIy?=
 =?utf-8?B?dW9nK00vMVhHRzdWTncxbk9LZzlKYmM3M292cUR4cEVvOTdxZGY2U1BqZXJN?=
 =?utf-8?B?SVd2VjRSMEtmd3owTUVhcVJka3p2a0FnNElHRXNMUzRGalJXa0JFQmRKWThs?=
 =?utf-8?B?WVJKUXY5U2JrVkdRcVRqS0JZeFYyVDlML3NRNll4aENBWFppRCtDNWFnYVUv?=
 =?utf-8?B?V0pxc3FVVGR5QndoVStnT3JISklNUDVObVBmWFpDcy9HeWxlRXdUWE1XaFdR?=
 =?utf-8?B?RW9TZHBmNTJJTG03cmtVN0xKS3NKb0RaQXRTWWptVzZ5SEE5Z1FOZmdxY3BJ?=
 =?utf-8?B?TjVjN29ML1lvZlpIWHBHa3RzY0hKd2MyMUdKTTB5SWV2M1NNbGplTXpGanQy?=
 =?utf-8?B?dHNjNzNDK2pJZzRVeGJZbDI3N205VFU0QVhmaE9BS1h0TUxmV3hjQ0lmS3d1?=
 =?utf-8?B?NnUvVXhyOU5sMWpnUThKYmlPTjVrQ1VLN0IzS2dSWnh1S2NSd2RUYkF1SCtQ?=
 =?utf-8?B?eFJrSysrOFdTeDlQNzJrVkJwamJQUEJjSTZsVEVzdUtxdWdUTFJ3VWp5RVhO?=
 =?utf-8?B?L1pkTnk0MkpZTlhJRHM5MytlSVQxZUp6QmhsNzhwTGN5T2RMaU1DRUEzOFM2?=
 =?utf-8?B?c2FyUTFvRzVlSERUeXVkVCt3dE1pWUl5cnBoM2VsVEUwaTdWSzVuV0lBeUJ2?=
 =?utf-8?B?cS9Hc0liL0o5ZjZaNGx2a3ZPMDJiR1BzaVNzdG10UCtBd2V5OEpCak95OEZB?=
 =?utf-8?B?OHZzTUNZYld3VTFoVGIraGVKZllqamRpVUkxOU5xbkdGOFcrRE9oYS96UEF6?=
 =?utf-8?B?ZkNpcFJDY2FsOTRpSjhkK1lPaGRJNS9JUlh5Zmd6M3BCNU5jWVRSY0xxSzd2?=
 =?utf-8?B?T3JPOEFNeWtzRUhxeXo4UHZIRHdPN3U3SXRRalVZWE9iSGFxaEc3cHdZd2Np?=
 =?utf-8?B?MlU5ZmJBMW1aMVFJeEZxNmVOTEVlKzZRYmxpbzB2cWR0bU4zbkY1RmZ0ZmVn?=
 =?utf-8?B?WjF5VnlMaEJMMndNbEw4TXJUbE9XM093SFQxUUVRNTZ3ekhFR2hGMHVaRHVX?=
 =?utf-8?B?dmFDTDJSMkNOMTEzL2NpVG9zUzlnSzR2Q3pBNVNoM3NKb1JwVHN4VEJUcEI4?=
 =?utf-8?B?UElaTWEybEFkaS92YjR6SXNGNThtWHhCYkxFZ1ZER3ljSDlEdEVqMkxCNzRr?=
 =?utf-8?B?SVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fc589a0-1c81-4939-5535-08daac61e11e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3240.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 14:56:01.7044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QnG7EZ7FFADZAD4y9aYzsbhmCzZj/HKtEXf8FrnZKwi33sQTBidXbvsvHpIENE5325ov/wq+gEv5s+Ez/6JprH7NsR1azc+X47zHpV5OR2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6072
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_07,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210120098
X-Proofpoint-GUID: vGypT1v5kN9ofS2N3IrX0Z6EQIu3yaM4
X-Proofpoint-ORIG-GUID: vGypT1v5kN9ofS2N3IrX0Z6EQIu3yaM4
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/12/2022 10:40 AM, Jason Gunthorpe wrote:
> On Wed, Oct 12, 2022 at 09:50:53AM -0400, Steven Sistare wrote:
> 
>>> Anyhow, I think this conversation has convinced me there is no way to
>>> fix VFIO_DMA_UNMAP_FLAG_VADDR. I'll send a patch reverting it due to
>>> it being a security bug, basically.
>>
>> Please do not.  Please give me the courtesy of time to develop a replacement 
>> before we delete it. Surely you can make progress on other opens areas of iommufd
>> without needing to delete this immediately.
> 
> I'm not worried about iommufd, I'm worried about shipping kernels with
> a significant security problem backed into them.
> 
> As we cannot salvage this interface it should quickly deleted so that
> it doesn't cause any incidents.
> 
> It will not effect your ability to create a replacement.

I am not convinced we cannot salvage the interface, and indeed I might want to reuse
parts of it, and you are over-stating the risk of a feature that is already in 
millions of kernels and has been for years. Deleting it all before having a
replacement hurts the people like myself who are continuing to develop and test
live update in qemu on the latest kernels.

- Steve
