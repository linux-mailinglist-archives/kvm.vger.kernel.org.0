Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B96D70929E
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 11:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjESJGx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 05:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjESJGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 05:06:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD89AE42
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 02:06:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34J6kMlQ018970;
        Fri, 19 May 2023 09:06:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=AnZPFcYtN3bxtlX7ZAxe2umUnUAZHbQKj+a2Mk6HXsU=;
 b=o6PuxfgdrVSlxvTEt+Dxs5jj+ouGapUa/+GEv+0UjVkP2pcPBsTwZPeC+XQo3f85QrgQ
 e7BHKthkvt7VspibfvpLovab3lqbh+79MGXXSnyezG/QWp1LFdeNaDFX0d/22b0e+sSO
 YdIDYKWjpNOHLdsmMuPimHw61Q1LveHDYFDK3T13pkDJqpTHn7nhYgypteuUVHma762R
 2Ki6JVZuxTlpxwZKTuyou7GaLnFCBYbRnYJgO1/oPRzPVMKsTxsAtSo5Z5ASo8nVlumK
 YMvJUNteMlZc7l/I40j7lqN8ViAYItpE7TzFCJY9mEEOFaYkbvoZMJAWG54mGIqpNgXN mQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj0ye9p5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 09:06:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34J6fmqr036369;
        Fri, 19 May 2023 09:06:16 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qmm04v8mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 May 2023 09:06:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHKC7wxWZTmNHDAXsrpf2EaoXmagLMv44JONaSQffWa0bRzsMjqUBuTAop0jrnyUZvY7AqzgZvvas+9Zu9wlvcVhaJRnbMBxa0B1RK0nkdH5UfaEpid2B4hyjfA/UZ4tzGc/+mUK1pXH2c1FaJW52HNjF2u0fJ9/Y6sn4bqeuwX3z2DgjK7/iUkaMpgQekhIj4WFzpVnGLV47cr44IXJIYFbhKj+0f3siTk4fcUcRPjscC+kBKCVe1MDqnWPRdpa5vIHt/O9eZNUsOKjyXYJ/WCAXfgqohaEFwDBytVY4yZrLfjLjLF6pXwPPJm6Z9qJvrqYEs8RhfOj4U5IYu4alA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AnZPFcYtN3bxtlX7ZAxe2umUnUAZHbQKj+a2Mk6HXsU=;
 b=Mqgzk2/vV1Q/aCBeXB42kHENpsfd/V6hr9HPvkRQWqoSbAzWVXlTCT3lzML8YNvT9Xgd3b6FctJ7mswLShKpEGGBH+1mn8SDaWz1XKEg1euZgy+7xGblEqmg1/B8SodmbHN/SYK21VjFX2o6IPsZ73RrR+nwrrwOVS4ZF0TryMmX/73PgVOk3TeMBJdSKRyE6GOyZ++yDkP3lS7YigMZtQoLore6iopFIy6X49+QzpkVqDOQoGcdZJmBwChcD5qpC2r+sMLN0G0AkSRvFRSSBwMT2quXRkq53TB16etDpU3/3Nb/2cpYG2hghFTEsJKJTI63aVotuVtD/rAAG4HOlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AnZPFcYtN3bxtlX7ZAxe2umUnUAZHbQKj+a2Mk6HXsU=;
 b=yjr5giISvarmrYuJGJdS1jYbhMYlB+LZFtioK9MBbeDpw3E7GVoV0yLTkPRrAZYggGyvhuhPXJYS5oraYTlRqnjSEWF+eW6HMHTZGPKZS4qkGypq8OGu4W0JdBQDwJJOAkqp+sqXeWeHG6Wl/8U4RpzeBXivl3nnTazQez/NQu8=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BN0PR10MB5271.namprd10.prod.outlook.com (2603:10b6:408:12d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 09:06:14 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b176:d5b0:55e9:1c2b%3]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 09:06:14 +0000
Message-ID: <e6696fd3-836c-c47b-c6df-91e63c4cc6df@oracle.com>
Date:   Fri, 19 May 2023 10:06:06 +0100
Subject: Re: [PATCH RFCv2 03/24] vfio: Move iova_bitmap into iommu core
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     iommu@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
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
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-4-joao.m.martins@oracle.com>
 <20230518163530.01d6b02c.alex.williamson@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20230518163530.01d6b02c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0480.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::36) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|BN0PR10MB5271:EE_
X-MS-Office365-Filtering-Correlation-Id: f0777575-8739-446f-5337-08db58484c1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QhO9aqIGsn5vjBITBenBstAkh6RPapOWpZMenQTwVT3n56FdErLa3nnOp04JPyg9PwfBWN7iJTqoVgaajc7/HUCO3PHqVl4O600bghWk/14Obyx3zGSi5/LO/R3r3iR4f0iNmzVrbAWhBVDwqtXN0lULa/LVDdaufvKJ4J8jTOLS/XpXlgk3Hubmm6BAnWSRL7YKR35anaZ1B7RlxDqpLq8SBqz22pB7rYj7U8sSNjZzIBeqvqM4slysPC17LV0KA3k3SkbGuTXOPHE9FPiDkjbEqVvUjNwpqIHJl+HQWikYrzjFq7470i/cY8KDw67MyOkF6mgr8xVk4I3lMs80wjPqMb7Ddw+Hy8wVNifE4GTnz/wT2fkHY72TjFpEY9LVme3VbsFcGFCpdp3PO2CVjCaX7ndTLmuy+f4o7r+cjYw+TNqg0gO50JzpvaYzFYc4aDZoqBaOF9PTRQm/3Rnv1lTCRuYBxhlA6ipTU/uqdI/u/qVhU5864yEm3NsjAXZGEvrm0QMgiM1UpGJzXWOY8pJ8ARwA1eZY9HvgDwAsL1xTpEjnJUL9RqTsVtlGVxpcElfGZoHLpE6IMD8lzNQMIT0HX7hUoYVFtLQh9hr0a1SvCbEZhUZgC6e1wa5ZYE7k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199021)(6666004)(6486002)(41300700001)(38100700002)(26005)(6512007)(6506007)(53546011)(5660300002)(7416002)(36756003)(83380400001)(2616005)(186003)(2906002)(86362001)(31696002)(8936002)(8676002)(478600001)(6916009)(66476007)(66556008)(66946007)(4326008)(31686004)(54906003)(316002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWNhU1RsTUFwRXNiaHppK2txNXJrSUNwd0RJVVNqZnhIOWVNYUFPWG9yNk1n?=
 =?utf-8?B?WmhWaDk4cXVsb3FtZnEvaTZjTExiOC95WjdodUt1Q01ZTGlzTkFLVkpPQktV?=
 =?utf-8?B?dytpS3hlQXNSMDZwMHdILzR6YWNWaG44MUNWRDJQM2lvTkxKcTR0UG9ONnVJ?=
 =?utf-8?B?SEFzYU0rSUtZNUlMQjFKNEJ0ZU1rUkNybDBIY08vK0FPTGdzWlVOOEhNc3ov?=
 =?utf-8?B?N2tJOXUwWm0xSTF4WUQvZDBzTWd4Z3FjMkwzQ2c3SU1QaWxDeDc0N285YS9p?=
 =?utf-8?B?UndQMnN6ZFJkTUk4MGFNTkdheWNXZFAvbjBvRWllZGF3VzBZSktqNkN5bzBU?=
 =?utf-8?B?akRZblhPeDZWRlg0eEErWmtsVlNiY0NrdkowT2dhdFN5ZUxsMXEwRGJlUUhp?=
 =?utf-8?B?TXhCYTlLOFlBS2psZ2Y0ZUxvcHFiQVVOaS9SWGRvZURad2luWWZvenRINENS?=
 =?utf-8?B?OThKaWRqWVkrQmNJWk5rY0F5R0tiZUxTRkpwcWRMcFlOWmR5QXdKeVFXVmdC?=
 =?utf-8?B?U0Zhd3MyV0p5Q2Z6MFhxcS9HWnNiU3BiWnIxZkdCQVMwWTRnU2tMZUFDbWJl?=
 =?utf-8?B?blN3QnhZYVBya1IxQkNTcUNtYWNjWk5Vd1g1MzhCZHJLSnB3VHlERnhGSmlD?=
 =?utf-8?B?bGorWnhGM1FaelEyY2tZTlducmVKd3pFbHdnNGtRUFY4RXdoTDE5Wnpnc3Ba?=
 =?utf-8?B?cUN6MGxOYzJJZkRYalpjV2lxRXpjNi9nTkVXYzVmSjNuZUVxY2wxZllKaVBG?=
 =?utf-8?B?enJWNmh5TGFGcm1nbUxLYVdlVzJJSklZMElYUDd2R2RlSWY5VkdoWG51UDFR?=
 =?utf-8?B?OUZydUh4WnNEQWRhRDVWZ29WVGt0TTBBaHBtMGdhbXlyRzczU0t2U1hjdTdm?=
 =?utf-8?B?KzlwbWxtNFU1YUNUcml1UENkTWU1QzFOR0hpTkNHSThuQVh5dXJKY3lxSWp6?=
 =?utf-8?B?YndFODA5VTRvWkM1OTc4RC91MHpaaUFJeis1MS9ocElNUVZ6Z1BtdVhrZFdO?=
 =?utf-8?B?bnVpdTJzQURCanAzMHA2TVdnQTZVNmREOWw5dE5MUGRhYVZNT1laQTFkdVBH?=
 =?utf-8?B?bWRKTHpnZCtwUVBrTDNUQzZPSWd6OXNtZ2tTQitwdk1ESEpDek9wTGQ4V3Nx?=
 =?utf-8?B?YjlSZlZINC95ajNxK0dFY3JqSXNJZ2RoZTlHV21VWlVjZytKY1QySzYxUzR6?=
 =?utf-8?B?MjFpK3pYZXg1ajc4dWtGc0dON1NwVC9qZU9TY1AvaHl0dy96azQ1M2VzckRI?=
 =?utf-8?B?Yms5S3FCaVgyTTA5OTJqOTF1NVdQR1ordFZ1akNSbzluZHVsK0theEZwam41?=
 =?utf-8?B?bVo5Ri9ZekxQMVVndDRIVzVKZTMxZjdwcFNPMDJmakdEWm4xZWsvclJoUXBa?=
 =?utf-8?B?b1pRODg4QXUvSnFncXd3ZG5GZUlZbjBQSUlXM2RISlJpQkdOMzdWUzJyQjVn?=
 =?utf-8?B?ZG9iaFlmZ3dMamFDenR6dGxSc1JvK0xnRTdkZGVrWXo4YzAvQmNrZjhmOHRQ?=
 =?utf-8?B?bFRLOFVMTjFxNERyaXFaN1NKaWFFeWdJN0E0T1gwNWljVEJrQkVvbkFrMDUw?=
 =?utf-8?B?VWZRdXpmeUp1dnBiY3FFQnBOZzdFUEg2MWxVc0krUFVuS04yMHJwMEZLSWJx?=
 =?utf-8?B?V3hyTmhDYkhRMWlSSVh0N09IeFBRQU5JaUx3dk5RN0xQdnRmMi80eHBHYVhx?=
 =?utf-8?B?RlQ3UlA1aGw0Sk8rUmcrWHpFeWZIbEJXbUQvVEswZi9MOWtUN2ptUkRtOEVw?=
 =?utf-8?B?bnVxamdlaVM1TE9WNzV5VGxCSWdXZmd5blJTZEFnNXF2ZExZcEpkUHI2WXZB?=
 =?utf-8?B?MWhscFI4VUJCR2dLUTBCVEtqakdpQlVDMnlwM011TnNrNVd4L3NPUkZYUWtj?=
 =?utf-8?B?ckZ4UTVDc2kzS29XWDEvS3d1L1l6NlR3WjJxRDJvVmRFcHJMamFlSS8ydklo?=
 =?utf-8?B?Smh1VzQ2cGNCa0M1UzRwcjZLU3pId00vbzMvWVJuWXJYUGZ5aTNSaTJDaVR3?=
 =?utf-8?B?Rlk4RWhSVXlJWkJETTFvdGhCanNSRmNQSThuR2g5Ui9kRzBuWXRTaWMrMnhL?=
 =?utf-8?B?UDFWSjg2SGM1UmlxVFgvK0ROajBwTUlNdFYzeTRDeVdKbVR2TW1wakh4R0FW?=
 =?utf-8?B?ZG4wVTdCNEE2a1hXVllNQ1NjUjlCS0FuVThSalAxUnp4LzEvZjhVMXYyV0RR?=
 =?utf-8?B?L0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SFJENHBwMjBTS3FJRFdVRHMvK1VTUktNNTcrWTBLbkgzZ2dHU1Nlejh6ZHZL?=
 =?utf-8?B?YXRzdnVYblF2RGhYUlBMMHhWZFh0cWJ2SzN1Y3VzbS9JcEhpSHdvUzNEY0I3?=
 =?utf-8?B?dERiYlcvWm5vU0pqL2cxS3BuWlk2QUpSbi9Dd2xDRGkza0FLYkEvTkJQRXR5?=
 =?utf-8?B?NHF2Y2dRcFplZHEwTUJiblRLZ1VnNjRzU3laaDR3VG43blpJaE5JdE1tNnVk?=
 =?utf-8?B?UlQ3bmdXS0lsZmE1ZlNoTUtVUDJYcEFBRGxzakc0THZvTytXdzVoYXBWVlpp?=
 =?utf-8?B?c3laREhuWk9HWG5WQklETEtUZkR2MHZoenRSQmhRRWNOK1ZuU0xxTHAva3h6?=
 =?utf-8?B?ZUJGUm1NOXRFd0N6ZmRBdGlUNHFxNUlsOVY4TkZqcU9mSUNGNWRUTzFRVnNs?=
 =?utf-8?B?ejhhd2ltSTJrQWMyS3c3dGRKaG5abWJvRkFWbjFWcjY4YURtdGpMbVpDZTBL?=
 =?utf-8?B?WTl3NTRFaTd2Y3hCYXZDNll3cGE3VkZsUnplU0V6ZFpYbklyMFZNcVF1Qk1q?=
 =?utf-8?B?NnlPOHVlK1ZFN1VWY1daL1FPQUZ4T21lY0lIUnorakFOaGNxN05odUtzWjU0?=
 =?utf-8?B?dzFwWUFGMmVGcWdOZFhyNUljWDJJQTZBeDhpbzRjZUVMMkJ0NGZrbXJOdmtT?=
 =?utf-8?B?UngwbUJveHp1T1FvNUZRd3lEeGc3THhialZyTDh2c0RwQitMa2NaeTc2ZXdL?=
 =?utf-8?B?MHNiVDZlSnBjbHJuS3pkYlhIem1sR0hsbWVwTDhEenJDVTFJbG5Vd0M0SlhF?=
 =?utf-8?B?ZHozbVVZTCtRZEpycENtSUdtZEdxeVF4b0lBSHVPK2xBTzRtdXU1U2xHNGsy?=
 =?utf-8?B?NW5JbmVCckpONlRjWFgvSE1QOWVadnd5M2dGdlRjZWZjd2dZZEI3U2x4OWRB?=
 =?utf-8?B?REs5K21mUUxYbnpBcFBROXhRZGNBRTE3UjBPZmM4WU9sTlc1aDJsMDRqYmpa?=
 =?utf-8?B?bDQzTHRRQkpNMFhQT1dpVTNDUFI4eFBzRnZkbDZEcCtjbHdWQnRlNllvdHJE?=
 =?utf-8?B?TTZrUDNiVzZoWlRRMEl5c3lHQjJPUHFQSWQ5T1pwT1hQZDhFUytYK0FrM0hM?=
 =?utf-8?B?bm0yMjRScmRPdG02NEdTR0Q5bEZab2twc0Q1R211YkRCUElteFEyY29aYkJY?=
 =?utf-8?B?eWJtdEJXa1dlY2FYVHIyTy9WUFRxMDBCZ3I3blNsUzNFT3cvLy9OdGNmem90?=
 =?utf-8?B?MjNmMSt2U3VhWG9ldFI1YzhjRW9uN1ZmeEVzeEJzU2tYNU9OVG12OGgxaWpB?=
 =?utf-8?B?d3dUWWFWODVqK0E1SE9Cd1dMckhybXNrZmdlUDZYSVJ0amliazVPTFlhQVRW?=
 =?utf-8?B?eGxUS1p0NTFManRIVzJlYjZOZ3lhM3YvMndmM05YWnExRDdhalYvRUtURUFF?=
 =?utf-8?B?bkRvaW9SOUhaMlpYcjRva2FZNzU2Y1ZsZXEzeXFxUHJOQkt1NnZrMlhaWnR3?=
 =?utf-8?B?ek5zczl2ZUx1WGxxczQ0MXYwajJ3TTBXZTJDbWxnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0777575-8739-446f-5337-08db58484c1d
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 09:06:14.3651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X1WBWx5mBlRC1LFqchW/3fE64/MXZleP8Y9H393fRcjY6lRxX2YzfAFylkXHCZoSowIUCgWXmd3DkQdzjpUPEu0fwXaDPp4yaEZAIMFqqJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5271
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_05,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=967
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305190076
X-Proofpoint-ORIG-GUID: ZP2hSbXyhCQ925IQBXkoHo9yxU3kO6tp
X-Proofpoint-GUID: ZP2hSbXyhCQ925IQBXkoHo9yxU3kO6tp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 18/05/2023 23:35, Alex Williamson wrote:
> On Thu, 18 May 2023 21:46:29 +0100
> Joao Martins <joao.m.martins@oracle.com> wrote:
> 
>> Both VFIO and IOMMUFD will need iova bitmap for storing dirties and walking
>> the user bitmaps, so move to the common dependency into IOMMU core. IOMMUFD
>> can't exactly host it given that VFIO dirty tracking can be used without
>> IOMMUFD.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>>  drivers/iommu/Makefile                | 1 +
>>  drivers/{vfio => iommu}/iova_bitmap.c | 0
>>  drivers/vfio/Makefile                 | 3 +--
>>  3 files changed, 2 insertions(+), 2 deletions(-)
>>  rename drivers/{vfio => iommu}/iova_bitmap.c (100%)
>>
>> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
>> index 769e43d780ce..9d9dfbd2dfc2 100644
>> --- a/drivers/iommu/Makefile
>> +++ b/drivers/iommu/Makefile
>> @@ -10,6 +10,7 @@ obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
>>  obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
>>  obj-$(CONFIG_IOMMU_IO_PGTABLE_DART) += io-pgtable-dart.o
>>  obj-$(CONFIG_IOMMU_IOVA) += iova.o
>> +obj-$(CONFIG_IOMMU_IOVA) += iova_bitmap.o
>>  obj-$(CONFIG_OF_IOMMU)	+= of_iommu.o
>>  obj-$(CONFIG_MSM_IOMMU) += msm_iommu.o
>>  obj-$(CONFIG_IPMMU_VMSA) += ipmmu-vmsa.o
>> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/iommu/iova_bitmap.c
>> similarity index 100%
>> rename from drivers/vfio/iova_bitmap.c
>> rename to drivers/iommu/iova_bitmap.c
>> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
>> index 57c3515af606..f9cc32a9810c 100644
>> --- a/drivers/vfio/Makefile
>> +++ b/drivers/vfio/Makefile
>> @@ -1,8 +1,7 @@
>>  # SPDX-License-Identifier: GPL-2.0
>>  obj-$(CONFIG_VFIO) += vfio.o
>>  
>> -vfio-y += vfio_main.o \
>> -	  iova_bitmap.o
>> +vfio-y += vfio_main.o
>>  vfio-$(CONFIG_VFIO_DEVICE_CDEV) += device_cdev.o
>>  vfio-$(CONFIG_VFIO_GROUP) += group.o
>>  vfio-$(CONFIG_IOMMUFD) += iommufd.o
> 
> Doesn't this require more symbols to be exported for vfio?  I only see
> iova_bitmap_set() as currently exported for vfio-pci variant drivers,
> but vfio needs iova_bitmap_alloc(), iova_bitmap_free(), and
> iova_bitmap_for_each(). 

It does, my mistake. I was using builtin for rapid iteration and forgot the most
obvious thing to build iommufd=m I'll fix with with a precedecessor patch
exporting the needed symbols

> Otherwise I'm happy to see it move to its new
> home ;)  Thanks,
> 
;)
