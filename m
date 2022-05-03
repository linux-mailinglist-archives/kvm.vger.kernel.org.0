Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9640E518391
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 13:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbiECL6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 07:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234686AbiECL6I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 07:58:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6FB2559F
        for <kvm@vger.kernel.org>; Tue,  3 May 2022 04:54:36 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 243AnFRR013502;
        Tue, 3 May 2022 11:54:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+24zZMznfpYH4Qo1RnKloy7vqFmISNo448KFJYa2hOI=;
 b=Ia+SgMUXWrWr7IlPM6G1cSCXKhKIuN37DT0F7QPIKKRa0Pg3GszbzLi/UD43xTVJ0Lzj
 8uIG92vJ2FLe/wvLDPKLUEGBnPpjDn3s6uCCBOGWxejogooRumXKb6NMcWKi5QXPhmKc
 fc7WaVR56+oXZRkkTcrJX1EvFVHSkK15HP8UBNRJzNd8QdEypp4SfN+n+RbuHk/QSm2E
 9cptt8Y4OAeoVIhz6HC+P7y8iFD4l6gd63x9hRObXmruPawizN8mazf/RmpC/QQKIgBp
 uxSjlWd/sHWQNlin8NOJHZN9+y93C2rgzK1FHw/e2ai9gi8do9+G3Bobu4PfrJ+NL9iq Cg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frvqsdgc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 11:54:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 243BpQCU006878;
        Tue, 3 May 2022 11:54:16 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fruj8ft2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 May 2022 11:54:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y95o5bf3CbZrXdcqDpEhjqWqzs58FNH1lOej5VhB9dOBqeSCC/kiPOQvCv+UgYddFwjuXw/pZL/LoUZA5IpBoRn5GVaBxI4USFCSGyYi+FSg3dLQ44QF0SOW3VKXD+J2UJAO3R8SVS12rFgwr/zaaQr2Bw1Oy8lTFL0dsjtiOwkXr1mRhmjnrabLC94LgZkR92nAti3E6A97YnnRWPjnHjTYhEXko2VXHvL2iZm/HOW1HYtp+PuMwRHdaHWUUOgDS2vOL3Mv9Gm5SRsMeUv7RJuTEaRUYz8LwJSYd75EAIvLZoDhjfboWgAlJ2k6cAUeXet0GS5h3RWZIfINcGyG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+24zZMznfpYH4Qo1RnKloy7vqFmISNo448KFJYa2hOI=;
 b=dZxAWXJ9qhMyA7PQ2Wsl9mByEVvIq6D4qc0YN65IwqQn9BGvx9v5fl4hJzHsRUIysH4sJ7PReXIiluchEqjc0myITA8YnOI/CranONphpaZKmrgbaa48rn7WvlhLnR5ctZAv/+iE7lo+fGEB4WWT5149ZTHYbARaYPh1PHLmofWk5tA7OGJxpOIjMpvYht3VhzkHRlDX6oQRabvNOYRqL6HRXcVl7frejbR9+9YGUkXcNJDxgFUQVturXthHcoo4N/LBjAEWsgNbkPdbz/WCz3llW8we5P/a/PYLkeWTpuxUXCLpluyv6FJQOviZrl6Qq2gaGIpydsK9+k2+dMA+rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+24zZMznfpYH4Qo1RnKloy7vqFmISNo448KFJYa2hOI=;
 b=SrpNZ9bWFqbldbUTTATluhtqPtqHRtVjjd6yBvH5yre2BNP0juSltHUNqgITr5K9K363TalPDCC9b265AeLg5CRsu0TobragR7uO4BlU7tAMl7UnknxCPlqko6FCFtfnPQHxqJ++DJlTA+Q7zQ4PWEokrPm8jnekYEzXHYtOS04=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL3PR10MB6017.namprd10.prod.outlook.com (2603:10b6:208:3b0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Tue, 3 May
 2022 11:54:14 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::b9e5:d1b6:b4be:f9d%5]) with mapi id 15.20.5206.013; Tue, 3 May 2022
 11:54:14 +0000
Message-ID: <62f26667-5ccd-619d-2e0f-eb3a3f304984@oracle.com>
Date:   Tue, 3 May 2022 12:54:04 +0100
From:   Joao Martins <joao.m.martins@oracle.com>
Subject: Re: [PATCH RFC 04/10] intel_iommu: Second Stage Access Dirty bit
 support
To:     Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>,
        "John G . Johnson" <john.g.johnson@oracle.com>,
        kvm <kvm@vger.kernel.org>
References: <20220428211351.3897-1-joao.m.martins@oracle.com>
 <20220428211351.3897-5-joao.m.martins@oracle.com>
 <CACGkMEug0zW0pWCSEtHQ5KE5KRpXyWvgJmPZm-yvJnCLmocAYg@mail.gmail.com>
 <f90a8126-7805-be8d-e378-f129196e753d@oracle.com>
 <Ymwsl5G/TCuRFja2@xz-m1.local>
Content-Language: en-US
In-Reply-To: <Ymwsl5G/TCuRFja2@xz-m1.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0102.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:139::17) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2f4c12b-48aa-42ef-501f-08da2cfba4fc
X-MS-TrafficTypeDiagnostic: BL3PR10MB6017:EE_
X-Microsoft-Antispam-PRVS: <BL3PR10MB60175DA4207766414CE33AA0BBC09@BL3PR10MB6017.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TYwxBNi83LhirtXQQ2UZDDDaS8OLOfTcfRFX1GeQhy/thbV8KUV9nFx3NKZzBzo5TLnGeEryBqnsMcLAwFDiC5euc0k5N3pkfpODAj3G4uz/qmfgKDPK2O9Fyal/uNLTOdEtwq5Ggyvo1MSdiVIg0f1KOn83315s/o4/H0P2BUhTiidoHKAvgjzeYnOpoqelwtAbK2yuVPtIGL5f65qxpPiTOW8KJURWD+KnSOqGTRrOUDt7K0mtI0eeNgg/fhvchZitpqj152IqKLWTRUR4UG96T/kDSJod6Fd7v090aO9lmbCbz/BvcW4mCHw9hGjuzHO9pq3HZPxM80E9obISce4vopIKFF/TPi8ZD2WmSS3D7nKiVDaOtVUMrhSqS7IjX3/fC5mPH+fYDq26iSYI9FwpPjG7fbGMH4F0ydjQdP2Cb4ULSUbG/1KoDamQgqSF85cDa5o0nSK5H9ubHk8gM978PXjvzpXq5seokQpbRo8IYuD+aWS2iZ7pqhr0TKCw1qwQbYqntUV/BGqZ2Kpy7HAMN5Jen2982wCzBtYpOk6Uvsd47XysKOzxbFwK6eEDDWjxt/X/QbY1eYZF0kPfzWVEKDpHt2tATNIazZJfuKDfmjBMrwEXr0zae+L4Aji4EUkQmnT8PFZYhdrO/Q77J4AzWrFk/wIOsYy7vYd9PK3ChxQyvZGkf+WQiKZhm3Se4Ptwtv3t27aegPyqAOY/aTnE5Hz/9IECQz6iX6lSy1Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(31696002)(83380400001)(31686004)(36756003)(186003)(8676002)(66946007)(66556008)(4326008)(66476007)(2616005)(7416002)(6512007)(8936002)(26005)(6486002)(2906002)(38100700002)(53546011)(5660300002)(110136005)(54906003)(6506007)(6666004)(508600001)(86362001)(14143004)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1k2VjBsZUNqKyt0eDBXajZlMmJDOWU2OVJEUktYQlowdXJVQ0NYV094d3U4?=
 =?utf-8?B?ZEpnVWpHeVBOTnRyMjdGNFphM2NiZUlPWmtCeVNDMjRUb3Ftd1loaGFMekdo?=
 =?utf-8?B?VUljTVUxSlIxZDZYcW9ka0o0ZDUrcTV4cHZsemp1TVNnbVFmcWFhVlkvbVZB?=
 =?utf-8?B?TVpXQkcwR2VwT3ZNQVRvQ2IweXVSOFIyVG45NWFmalA5NTUxdGZPT3JOeHY0?=
 =?utf-8?B?WjlTTjFBNitnOXpTRmRsMGZWcGJLREdHVVdyS2dNYWFtWkFXZHpYc3RrZ3Vl?=
 =?utf-8?B?Q3VFa3dGY3BERVc1UWdmQjNsZ2lqUzFoMXlNcGNveTVneThhbUowWFJ4V1RM?=
 =?utf-8?B?RWJTV3d5TGhyVmY2M0hhYVg0YnR5WitjOEt2WkZvWHNMRmdvRytrZWpIek9P?=
 =?utf-8?B?KzFaSDkvQ0FOaGI0NFNuUHRmRzRRWGhPK0tNQzhQQ3MyRjdhcVVQY216MDZk?=
 =?utf-8?B?Ym1XWGtBNndKQmhjWHh1V0J4MmNZL0o5Q0VxMzdzOVZpbk02djNubmpvYllR?=
 =?utf-8?B?TnpLVitTalVRM0VTTmRPY01Ya0xuMGN4aVZHVUsvdDVIT09DMzRkWi9OVWFl?=
 =?utf-8?B?MytFb3FVN2owcXNrV2pjVjlPdElINGJESEtBQjlNV293UGw0NWc0eWMyK3dr?=
 =?utf-8?B?ZkVTMnlqZW1BNFJvRlVwNGpkZEttaHRneENHUXRQS2lLVDdmMGRnSWVIQjZP?=
 =?utf-8?B?R2wzdDlLK2EybTlqNzdWc2l3dEJVMVVsOVVOUG5wTlhqbld4VUlISVkwV3d4?=
 =?utf-8?B?MHFGWS9BaFNtU3NWK01TR1lGSzd6L042QU1yUURWaEU2Y0JDUy9JZXhuK2ln?=
 =?utf-8?B?Ulp5ckFKeEtoRTF6UUN5MzY1YktBdDlEekRRZnorUXlrMDJHSjNLVmpYdTZS?=
 =?utf-8?B?OWo2aFB6cXVvZDlxQTZvZWF2dnoxNytnZDR2cE92dlRUdnRHK05ndXA0MlEx?=
 =?utf-8?B?MDByWXJnOFhENjB5enJRT2dUcGNxVjJXaXl2UncrQXNuYzQ5SGVwZmd2QnNm?=
 =?utf-8?B?cGM2ajcrT3JaMUl5SWxSOVlmUElMK3ZTRnZaN3U4Yzl6QmlnWDBCRW93Unc3?=
 =?utf-8?B?bVRhNlV0dFBlUGw3Q2FXOStUdGtGMGVpRXlsVEpPaUIxeDY2QmFub0VVUGsx?=
 =?utf-8?B?dUhJZmNYRHJmNlUwbXE0M1M2aVJFTW0raFYzN3Ywa2ZoY3JKMFQvbGdmSUdi?=
 =?utf-8?B?V1dTNk5FV1MzMDRmQ2o3bmNlQzFHZ3diZkg0anFGdnI4dEVhQUtHR2Vsb2RE?=
 =?utf-8?B?TEpwNmxpZDZsdmNKUndubkY3YWJZMHVzRDZNN3lFTUhtdkJ5ZkVzVzdDamR3?=
 =?utf-8?B?QUErdURsVk9TZllhMFU1SnFXZFZCRzRiRmVEZnhnWnBxQ3FWblREaFo1KzBa?=
 =?utf-8?B?K2lXNndSS2hsUDlzWGtiblRTYzVkWnZWVXVMR0ZVU1FMb2lOTCtZb2ZUQUdS?=
 =?utf-8?B?MElseDZzMTBPSSsraE1DN3ptbW0vMjY3RW9lNWJtUXlmSmNOYzhyZSs5REZZ?=
 =?utf-8?B?eWR6Nlppd3pNTG5RaDh6WjNIS1dKTE9PQlU4ZDhSTkFEb0htRGFLRW4yWTI3?=
 =?utf-8?B?SXpCM0w4cDc5K0lCYVU5OWFRaWpFbTg0TFN4T1ZuTVRDWVF3WmNLUHhNWnRG?=
 =?utf-8?B?N3V2Ky9hOXdNcnplZE9RY3F1cnNNclpHaGhlZDRQYUtFMmNiWEZ2QW1memdr?=
 =?utf-8?B?aEFzQ2JMbEk4RGZzL3hhVXROeUdWalVnRTB5aFR1dTBSbnNQWFJhZWxVbW91?=
 =?utf-8?B?ejJkZ3I2K1JJVXo1MXU3b3ovWitOWDhTN3JFWkovL2lRVnN4RFRpNXl2VzA0?=
 =?utf-8?B?WVNISnUyNXZzcENYNTRPeFZJNFRwZkpDUUFKamdlNkI1eDhWeGk5NkR4OUdH?=
 =?utf-8?B?Wkl6alo0cDZLT3c5eVFKN01rME9OL1ppTmJDUW84enVyWEVyc3ZNRlQ5NkZS?=
 =?utf-8?B?a2dPRzhMdlZ1NGR1N1E5dm44TkhBOEtsNHBhbmVCZkNCN2xNeUVwblF3OFpR?=
 =?utf-8?B?bG1oLy9UcXc5MnUrZFhtSCtJMjNTdXhocENjTkhSNVRyR20xdUJncWlhWVhS?=
 =?utf-8?B?VXhPczJYSXJiYkxKZnBNMWR2dUhialM4bnBkOUtTM2pINWoxMTh3NzBXT2lB?=
 =?utf-8?B?eHZXUjhlWnliL09RSlNFdGU4cGxYa0hRTWo1VFFWM1czOWhUeFdiaUkzUksr?=
 =?utf-8?B?ck04SFZoS1gxMU5JWFNIeEFKMVRMZDk4dmtsYS9lbDBGT0NNSlBsY1Z2NFVG?=
 =?utf-8?B?VTc1MURtakdaU0s1cGZxYXllcnRpWDlycmdScUxQVkIrTGx5UmZkM3pUbW9U?=
 =?utf-8?B?RGJMUjdwOHhWLzBCLzRabG15WnVuc1JndVl2WThuYUF2OHFjK1RNck1JcHdY?=
 =?utf-8?Q?ojNJTb8BZ9FohyV8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2f4c12b-48aa-42ef-501f-08da2cfba4fc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 11:54:14.6039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1rjWYpgHH3kOCMUXgMDQnj04sGQP3IcwMW2WFwCZWqW/sweXoO3Uty66IyXXrtada8hu5LBSIJZaRgJuRkiUDYaoInuEfxK0R6KUXPl7PWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6017
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-03_03:2022-05-02,2022-05-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205030088
X-Proofpoint-GUID: F8SQzuQRb3lJBSr_EPoSpuHD_8UquNaW
X-Proofpoint-ORIG-GUID: F8SQzuQRb3lJBSr_EPoSpuHD_8UquNaW
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/29/22 19:21, Peter Xu wrote:
> On Fri, Apr 29, 2022 at 10:12:01AM +0100, Joao Martins wrote:
>> On 4/29/22 03:26, Jason Wang wrote:
>>> On Fri, Apr 29, 2022 at 5:14 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>> @@ -3693,7 +3759,8 @@ static void vtd_init(IntelIOMMUState *s)
>>>>
>>>>      /* TODO: read cap/ecap from host to decide which cap to be exposed. */
>>>>      if (s->scalable_mode) {
>>>> -        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS;
>>>> +        s->ecap |= VTD_ECAP_SMTS | VTD_ECAP_SRS | VTD_ECAP_SLTS |
>>>> +                   VTD_ECAP_SLADS;
>>>>      }
>>>
>>> We probably need a dedicated command line parameter and make it compat
>>> for pre 7.1 machines.
>>>
>>> Otherwise we may break migration.
>>
>> I can gate over an 'x-ssads' option (default disabled). Which reminds me that I probably
>> should rename to the most recent mnemonic (as SLADS no longer exists in manuals).
>>
>> If we all want by default enabled I can add a separate patch to do so.
> 
> The new option sounds good.
> 

OK, I'll fix it then for the next iteration.

Also, perhaps I might take the emulated iommu patches out of the iommufd stuff into a
separate series. There might be a place for them in the realm of testing/prototyping.

> Jason, per our previous discussion, shall we not worry about the
> compatibility issues per machine-type until the whole feature reaches a
> mostly-complete stage?
> 
> There seems to have a bunch of sub-features for scalable mode and it's a
> large project as a whole.  I'm worried trying to maintain compatibilities
> for all the small sub-features could be an unnessary burden to the code
> base.

Perhaps best to see how close we are to spec is to check what we support in intel-iommu
in terms of VT-d revision versus how many buckets we fill in. I think SLADS/SSADS was in
3.0 IIRC.

I can take the compat stuff out if it's too early for that -- But I take it
these are questions for Jason.
