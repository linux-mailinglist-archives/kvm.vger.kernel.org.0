Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8649765C5D6
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 19:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238704AbjACSNL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 13:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238711AbjACSNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 13:13:06 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 342D326E5
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 10:13:04 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 303G3oP4002413;
        Tue, 3 Jan 2023 18:12:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=wpaj3re8fLqZ0EDWvsWMUVlmGf9vxOFkatCIl6rjtaM=;
 b=BqtYqZMPgYfI+rmWTZnIGUuESx7dsdHvRnEBO/wuWClZUTU5sRcksOra+cXyN21aGrmC
 FEkAUvhaivBt+h2rN/V5foLUEqKzgr+ganDvxeCndJje6SMvECP9xG0nd1ozg0JWrGU5
 ZiLfpGJMPPrcy2lxrRvBOYjX5C0e7t6oCLqsAiSWNFJ7S0JLQa842jThuvSw7j4y30bW
 uI6wTuILbn8Ut124fBr3Bvusz9ZbVa0jvhK7m4eMEvCbs0rRkIu11QMCfKmUN5OclJzc
 op6HLKMyrvSGOkplyXGqeE9s+fi3OVwb3T0EI5MUBgbIZ0b1EwJIXmEAig343NowDrCC xQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtbgqmsqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Jan 2023 18:12:59 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 303GcUlI012284;
        Tue, 3 Jan 2023 18:12:58 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mtbh56huc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Jan 2023 18:12:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cdc6IWtxjUl1ioP+vI3fzxK4byz2XYn5CWbdhe63ZM6GstTaWKNVlH3QkJHDntCjQEJUw57lNfoUCguOroe3DtmHhmkO+2Sjs/6hxzG5cgX+XwyuYP3X9yH4naIOQrdzneZ69hcQtcbDbD+XYg1hbrKg2ad7iDb6GacvYRRymMV49D+A9XnMyZxijK7UdG6JWCAL4cfMUh0nb1iLxZs+yyjkk1IJH2XOKvwmufQxy0dATWAktmrM7hXSofUy/b7ozGKL0EZRGoPt5LAXQj4gxnvStiXRNUMQhKr8lua3wqiqyBW693j3zkI5fHVT7RtDesnyE06SklhlGjnyNasoRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wpaj3re8fLqZ0EDWvsWMUVlmGf9vxOFkatCIl6rjtaM=;
 b=da1lcJUfJKfwjryyJ2SB3jtZJanAKieh0g1xZT1an1f/6G2PE440Y/t2vaaBwmF8h3a3XHhJpP6nRlLTE+FU/1zDmS6b/ABWn/5oTvDmEVtMnY4Upkai5CwPrXKozkUOJdEGBQBpFGDgYTnpAbtLO2FVseimAU5Bhol2V7ZnRy2l3VMcGcji1pZ+63Pt1/6l6gZusrCEUcrfY80Xph4WbIsW7FXR3ng6JGOfxhgHhorJBo5/aeospzNrRB5JItmkZj2jpU8gkj0OLfWu3A5j93Es99A+OpDoEllyPqZe4joapBEsd45vhi0Hqk2weEpkYp9oSjd59sWvCJKga8rLkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wpaj3re8fLqZ0EDWvsWMUVlmGf9vxOFkatCIl6rjtaM=;
 b=PEI0UmYnmEuJ/YXenVa0RQUlC/3GfKLFVn8Xq+EBmYw0a0rrCjOM5LqiE9djEaHb4zE/Sru4H0cPk+QSKRZMSJQWfWpRRICp4hJVeU+9HOSi4VDqD1xocWZ3xVUHCCXQR+47r8z/xEymzPlpRFga7LDBZVSdBldg/kW+VXdIwtc=
Received: from SA2PR10MB4684.namprd10.prod.outlook.com (2603:10b6:806:119::14)
 by DS0PR10MB6946.namprd10.prod.outlook.com (2603:10b6:8:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 18:12:56 +0000
Received: from SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca]) by SA2PR10MB4684.namprd10.prod.outlook.com
 ([fe80::3667:7f89:cdc7:9cca%3]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 18:12:56 +0000
Message-ID: <61e24891-28a6-8012-c2c3-f90f9c81c1c0@oracle.com>
Date:   Tue, 3 Jan 2023 13:12:53 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH V7 2/7] vfio/type1: prevent underflow of locked_vm via
 exec()
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-3-git-send-email-steven.sistare@oracle.com>
 <Y7RHtRnHOcrBuxBi@nvidia.com>
From:   Steven Sistare <steven.sistare@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <Y7RHtRnHOcrBuxBi@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR12CA0019.namprd12.prod.outlook.com
 (2603:10b6:5:1c0::32) To SA2PR10MB4684.namprd10.prod.outlook.com
 (2603:10b6:806:119::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PR10MB4684:EE_|DS0PR10MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 15928312-298a-4755-b95c-08daedb62353
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4oG1MkHF4NitBDkSckJoVxx+7dh69AB+RJtUjCUUWSgD1XKb2KPIG7Da3Xe1GdVI1mMEdMiHBMf9zk8oHacqUz5TRFMvcL6MsWXV9Owl7wAX0t1BX3srl3YUP+xU55nxt2SaGqJYdoHlPNMPIJSfd4IliRiOo6BCTSZiB3UWi6GhxNHgiMl4tA2kxE8ByOTHaxpKmsXnFcZWfbFZ1Zbj4Am4hwMqxAxfdMW8G7Am8Pm/NezvjNuaURodwyJrRGTZFy/voMc/CSnmfOexZE+4wUJVrWSXguLuifJ3TMXk40Wq661Ld9bTOM8zWBL9bZMjwHbyOoGb1g/BMAsp0XM0+41Jf+W4ksFsw6EOGT4eN/kpLc0FkdLNiDqz8XF4V679cmwGkT2KqogOUwPV/4frKvuC6a+qaan1p/vlzlMOeH/F19hegDhodFG04kWxmqegcE9Yvx0wfhNlv7wJ5O5n3zpjiuCdxhh/Qc2Hbo+Lv90CAlHANWcE298Jm4Up+9nR7e4s6dCf1IoiehXD6yfjzPYxiUHJKmspNyStukdopNIx94FvHqKDaSnM6a2w/fmd4LA43IEpHeISsYKXjZz4sFL/aWIhRXKPE2wx4zJ+aVCCovImhU5RzDbvcvHfdFtW411A97iOdgawJq4l+Ng3cWBaDDgp7tAIDqfRDpqXNdsOTwS6h92k9ULj5uXUagFFdMjVLZyMRN5TGiCuyW8qrYC1iwETQ256x+kwG4OYelMRJk5oasJHw/39UBnptl0KlBKR5CBYKGRPYE87RdmnqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR10MB4684.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(39860400002)(376002)(366004)(451199015)(38100700002)(478600001)(36756003)(86362001)(31696002)(54906003)(316002)(31686004)(6486002)(2906002)(2616005)(44832011)(6506007)(110136005)(26005)(66476007)(83380400001)(41300700001)(4326008)(66946007)(8676002)(53546011)(66556008)(8936002)(6512007)(6666004)(186003)(5660300002)(36916002)(22166006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clJZNmhxUTZWd2ZzUmN6UndFdTZOU1haMW83bG94QXpDaUQwcXpFNmIrQnNq?=
 =?utf-8?B?UUdIOFQyZGZDQmNyU2NlZzJOQ29XWmVNQ1pLOWlKL2VIRWFuWEJmTWd6K0NW?=
 =?utf-8?B?alIzTWQ4a0Z6SnRYQktjLzhQa2pnMmdxQXZZdHNsRU44QU5kNm1FcngwdHhw?=
 =?utf-8?B?M005Q2N4d1lqYit6RzBQNDYzT1YrZTFqTnJnUUxkc2xhY1EvdkRvYmJXL0dv?=
 =?utf-8?B?Mzl3byttWW0wYlB1UzVLN3YvUkhpQW5iMHBwc3FRYkRjUGpmczNXTlE2QVoy?=
 =?utf-8?B?ZmRIbFRJM2Q4enRUY2dJekc5Ry93Ums0aUZXWDI4ZUJhbkI1L3dpWGRoUWhF?=
 =?utf-8?B?bUVNQmR6SEZ2aDU2dDdHaUpjT3JpK3VvRk4rclU3YWVnUitHRnZjdUVZUFYx?=
 =?utf-8?B?MVErbmJYNnozMVlPZDFIY3Y3YkZnTWpXZGtJMVpVbGtSQWVoN2JrSXBycUZm?=
 =?utf-8?B?MXR0eVNZMWxHK2ZlZW5vQUxyMEs1NDF3NmVHaVJudmlsb2tpZ0FvUk5TOXZs?=
 =?utf-8?B?R3dmTkk5WjVVMzE4bTZvLzUwazJkV1NGQWttUHFLZUZhdmlIM3dFNHBLcldH?=
 =?utf-8?B?Q0puSGdMZnBJQXUzMWNzcjFQS09lOXhjbGFsZm01YzVDLzNuc2xwQTQ1SXVV?=
 =?utf-8?B?aXFMa2JOZ1BFTkdQVTFQTndIMlNOQWl4cDVwRU1PVWtCUkVIRjBQSllWTkU3?=
 =?utf-8?B?NEJSODhwZFpJV2hBemlsK0VPZURQNHJac05nMkpNdno0RXRBbzRSTEZnaHJL?=
 =?utf-8?B?L0ROazZTR3AxMkhXbHRpalVQODlCZkxaRysxazZtL1A2d2EvUC9Ed1JBU2NM?=
 =?utf-8?B?eXJlYndkRy9iTHhxcG5GUkdzWXZoeFE3aHpOcVh0R01OUUtDSk5GNlhQZU1R?=
 =?utf-8?B?ZTFReFA1Vzc5WUI2WWdjcnJ3Rk5NMVpibTlxTDhxc1MyYVJ4d3Q4aCtLblpq?=
 =?utf-8?B?RjJKZFZBWFJtRnlKTWJDNzBBREltVnY3VGJLOS8zUkVCbnA3NlpRNmFYZmpZ?=
 =?utf-8?B?NzlsRS9MT25ZeFE5K1Ntd1dadElaUWpUeFJHVEphbTV0ZExOdlI4aHNreTA2?=
 =?utf-8?B?K2o5R2ZuKzgwU2tPMDE4Szd0VDBIVlNRTkduK1F3OTFkNFN4TVQxcFVlM2po?=
 =?utf-8?B?TmFKUlkrK0xKdFd6NXJoUFFoUVVTMG5leVYyRkVmRUtXMXA1UEZKNzVZSVMr?=
 =?utf-8?B?bmkzWUx3YVl6RHY1TE1jUlJEbkdLZWdrd0E0NkNIOXhXdGR0dmdxbmVEOTNS?=
 =?utf-8?B?Qytud29DeGZLc3BDbGtkZVkyOWkveEp6TzNjM3hFR0dtRGViRlU5aXcwbFpQ?=
 =?utf-8?B?SnJyVnBjQldVMkpXRkZQdFlkcmY5NEVMaFBhM0srSEdmUmUxckljMENSTHZK?=
 =?utf-8?B?dXpMQVU1RlZNY2hMR1VuOWZTelJibnRoaHM0RUVvMFNJL0tZREZWeTlhbmxY?=
 =?utf-8?B?bGZJNmxSL2lVaG1FOURaVnVGUlRrRklLWTZRU1NRQUNaUzJvMkREQUNFQk5O?=
 =?utf-8?B?ZndQNWdwaDliNjJXWHFzSXc2K0NNbUd4c1dtcUEzaUJXcERDeFNYUFdEUUhD?=
 =?utf-8?B?Q2JwcDFQU0VCaFFrUDhJY0FTSDJqOE80M3RtT0t5WE56b3Z2cENQcUJ0MlVo?=
 =?utf-8?B?OWxUdGMyb1h2Q0t5VEhBb0tYYWZqQ2QyQ2lzU2FYbHdZRjZrcU1pMjEzbGQr?=
 =?utf-8?B?dGx6dHVlMm55ejNlZDg2QWtJbVVaTGFucDg4My9TNFhSSlNOYnpMRDZMTGdy?=
 =?utf-8?B?VHc4VHFYdEo5Sm8yak11akNUb3Z2QkRKWlFXbnV0dEFvOHZQUmZnc2JkVGJ4?=
 =?utf-8?B?K2wvR2lnSnV2L01ya2gyQVRxUnZtTGFXQWxPaC9vVFg3OXNYYjl4TWc4V1Vz?=
 =?utf-8?B?ZE5iVFlybHByYTZacHdXV2F3QzNpVHZCRnFBSWRXaUVDbDRNWVY0K3FYTWZ2?=
 =?utf-8?B?NW5TVU1wUXNWeCtQdlJUTSsydjlpbmlqQjA2bk1FcUVkRHViaEJHS2gzUGxS?=
 =?utf-8?B?bW1keXRhbkxVTEQ3KzljR0FTSTFsVmdjVDlsN0RjYzZXY3FXVG43aWIrNVVR?=
 =?utf-8?B?Nm1OcGU2akxBU1ljL1ltZDhGcjZNckVWY1d1Z2o5YTJNM0M3RDRhTjZ0WmQz?=
 =?utf-8?B?Z01WbUR2Mnc1dkQxT1k4M2VFaUxIK3EwZTFudmxnb091QmNyZVo0eEx0SXUy?=
 =?utf-8?B?TEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +MZOl3A7B2RA+ddNxJkPmA6XTC5dfwFZ3wSINWYLtKesU+1b35o7XGO1PpBGJ+oVxkg6s/dBI7hGRP56Q5KmRumiKehvDB2npHUbjQ+D2NVC4ZvLVvwHE5FOL2tKEUbpLJQzobJl6+H4k9vW95SQNZ3WqjwsCSX2q+Ht9COEi3xY+sZ7jERNzTcvHRisTdyNROLi8vINv5wAvm1nlXdnLiEhJYdpjkyVgTBI3JpodAZj0l30EYCQXnDs7DmLT4/6AnKpN/Qd9iROBoTILvLzOrHDfsA/5jyd3CZgAff4t5ea+7D2fpmRxDWrMu/E0Zs4nKJJ/746bH+mQ9Qjejp4GWcK/wq0rggd7nVxuurmyF3ii23Pt/xq7fhusM5gJoNg9vHGsvZ8hlHaBGOYvnOklIVoadK5wGJlNp1/F/3niiT7gIwZmFo17YZFE4dXsTZpuLSjTfPKhmuaUMVn8MUUYEQgVZU6oQ89Wcrt4NvzG9H+7MCV++xaJxgWdIgatEyJUTYKuCurxlMS7gN31VImMlLTdE8ZcQvk9nOBbu/MgzTQIF9SB/wO48ppJtKGCZ3gXb6/PjvTVWB94o/sDj35tJisffuahsmrCUNeM4aN7HA7RtTgcfDcngw1kE9wJYo+LTWnAJWKJRIfHs41Wh8b9GZfR+e7/XTyi1OFb5gKtL0ojDm+8XBf5r82I2K2rvdZ3YMiV5vfKpeN++QF1NmIPTBUvXfquOpIs41FVoyYHD0FcpMHOe4lkHmDv2CMBdyl5oZCWWW/dyasQcHF9frLAjEny0dO/S479AmviOjxSWKgMobeTQPrI5PEemsIZslwGX01EIcwHl5ippO7t/SIo8ALnkWB79e9wXOP3l6z1FWnoEzM576hcN5j5YPQbxCc
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15928312-298a-4755-b95c-08daedb62353
X-MS-Exchange-CrossTenant-AuthSource: SA2PR10MB4684.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 18:12:56.0272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3Z49j3duzoXkbr/1Zi+tQlZcC8rVsdo3FjqZQHDs3REBXIXcSc/ZI9osa+dATsQ+m2nYwUaIj6wm5j2SoCWS/ZDCgkcfLTqtRzOFOP117w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6946
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-03_07,2023-01-03_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301030155
X-Proofpoint-GUID: DUtH2esik2Fs113LTS-WvAc2daWNMR0J
X-Proofpoint-ORIG-GUID: DUtH2esik2Fs113LTS-WvAc2daWNMR0J
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/3/2023 10:20 AM, Jason Gunthorpe wrote:
> On Tue, Dec 20, 2022 at 12:39:20PM -0800, Steve Sistare wrote:
>> When a vfio container is preserved across exec, the task does not change,
>> but it gets a new mm with locked_vm=0, and loses the count from existing
>> dma mappings.  If the user later unmaps a dma mapping, locked_vm underflows
>> to a large unsigned value, and a subsequent dma map request fails with
>> ENOMEM in __account_locked_vm.
>>
>> To avoid underflow, grab and save the mm at the time a dma is mapped.
>> Use that mm when adjusting locked_vm, rather than re-acquiring the saved
>> task's mm, which may have changed.  If the saved mm is dead, do nothing.
>>
>> locked_vm is incremented for existing mappings in a subsequent patch.
>>
>> Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
>> ---
>>  drivers/vfio/vfio_iommu_type1.c | 27 +++++++++++----------------
>>  1 file changed, 11 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
>> index 144f5bb..71f980b 100644
>> --- a/drivers/vfio/vfio_iommu_type1.c
>> +++ b/drivers/vfio/vfio_iommu_type1.c
>> @@ -100,6 +100,7 @@ struct vfio_dma {
>>  	struct task_struct	*task;
>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
>>  	unsigned long		*bitmap;
>> +	struct mm_struct	*mm;
>>  };
>>  
>>  struct vfio_batch {
>> @@ -420,8 +421,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
>>  	if (!npage)
>>  		return 0;
>>  
>> -	mm = async ? get_task_mm(dma->task) : dma->task->mm;
>> -	if (!mm)
>> +	mm = dma->mm;
>> +	if (async && !mmget_not_zero(mm))
>>  		return -ESRCH; /* process exited */
> 
> Just delete the async, the lock_acct always acts on the dma which
> always has a singular mm.
> 
> FIx the few callers that need it to do the mmget_no_zero() before
> calling in.

Most of the callers pass async=true:
  ret = vfio_lock_acct(dma, lock_acct, false);
  vfio_lock_acct(dma, locked - unlocked, true);
  ret = vfio_lock_acct(dma, 1, true);
  vfio_lock_acct(dma, -unlocked, true);
  vfio_lock_acct(dma, -1, true);
  vfio_lock_acct(dma, -unlocked, true);
  ret = mm_lock_acct(task, mm, lock_cap, npage, false);
  mm_lock_acct(dma->task, dma->mm, dma->lock_cap, -npage, true);
  vfio_lock_acct(dma, locked - unlocked, true);

Hoisting mmget_not_zero and mmput will make many call sites messier.

Alex, what is your opinion?

>> @@ -794,8 +795,8 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
>>  	struct mm_struct *mm;
>>  	int ret;
>>  
>> -	mm = get_task_mm(dma->task);
>> -	if (!mm)
>> +	mm = dma->mm;
>> +	if (!mmget_not_zero(mm))
>>  		return -ENODEV;
> 
> eg things get all confused here where we have the mmget_not_zero
> 
> But then we go ahead and call vfio_lock_acct() with true

Yes, I should pass false at this call site to optimize.

- Steve
