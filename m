Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7326BDAE5
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 22:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCPVZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 17:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCPVZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 17:25:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DA9DFB75
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 14:25:39 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GL8Ybf032447;
        Thu, 16 Mar 2023 21:25:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=wvSLlFLsnjzmzguh+L8+dCYdF022s6SfTA7hMAGOIqQ=;
 b=nGEZO4IVWWuOt/6FDjQ3zk2ma3NZLzb4bprltsLHoq4LwMAxoJ47FxK46GD9rqkfhtaM
 Forts8cgdMOo+9Zi337M4e2JfhO3OtlOZdNBqKt/W2g0VSMbLbZh1mzil/K6Gc+UWqUg
 WbFi4+rKwj0qo6MYwoZ6y+B3u0ezzXoPg+i3YRxm5OfeXxjIElsnVtwnNw2DhC9pg8Ja
 KMPGpoKN8GBMUmKihd+dYkCELiu4TBTs+GMlHf2Oz8dc+fefzljHECFeF9D4ubJ6EzZh
 uGRLFQWVluNqFQgD8YIdPRhJlAZZ13yamTAxZNi0icceFv0svSeQu/TDHvzXjYFE8XLk Nw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs2aja2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 21:25:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GL3Lt2037064;
        Thu, 16 Mar 2023 21:25:19 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2048.outbound.protection.outlook.com [104.47.73.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pc01qdb8f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 21:25:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0pMh8f3+TzH2QXakosmRaVLLj9seSwWUT4lHgWVS1ZhEQwtFvICPY0OWTQWsLmJY6yelDFLsFk44K49BBDd94cye+l1p4UTjRt/MDYPfrjf48Y/yLKVM0+WvBTKRT40C7qiPeH3xVF9U8EIUyT6WfNZG33nGfFt+kmHyQE+293U3ITdLFczvXn1BcCf+tcDe8ouSl8LDGZURYnQJXRlRMiteBbuAStGOUrp/wvdRy+TfgY16ZP6yMBkoo8IxaPtiGtIFlpXBXpXML5XSQ/8If3NcowmgCgyJKdWFQK+jv3NxkVuAxz4SrFQvUWMKYa0iIetGzPUG3G5cFp/SxDvJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvSLlFLsnjzmzguh+L8+dCYdF022s6SfTA7hMAGOIqQ=;
 b=M9S10v4vn4WO8AtxmBSyi2CFQKB/qJmKByQPSNdummPd11N5uZFiM0oLZjISTMzaPHtZQCMzU+LLT3WUizoz39AvVtBNTpH/rswuC6y7M32vpQByin+MwOGFjES9gnJt+5iMknXfXmfPVTVsURKLBh763XKaYP91MT6irWUVoOzwyP4MDKV10Qd2jt+NHKYBb/XQBM+O5UeO8iJOlkP2Q0G/4mk75Z7q7w/wKK666SGXL4egVzZuH7tXDhRsJiQ0ga35lcxBRz/DTTI6IcihfcGJVaL618ismqIrPmLEVeOLqbk6ts5fMZBgex3ftDQENIEaOxgezS6j3/9ceWqHow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvSLlFLsnjzmzguh+L8+dCYdF022s6SfTA7hMAGOIqQ=;
 b=MXJxVYV6vJBpi/gWy8qImUluwNuOedRgUaOJ3uTSSU1XsCAvx2Txim7SYf85fZQnuOpHAqga7OPkV0KAWdUF7by7nfX8xkY4TytEa/RD4JSvzkqoYlpnT/bSxfzLCcrKmWKOyIWKvjOujkWA4B/bNC4aY3/leCL3vikgBU7LILk=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by IA1PR10MB6899.namprd10.prod.outlook.com (2603:10b6:208:421::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 21:25:16 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9b30:898b:e552:8823]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9b30:898b:e552:8823%5]) with mapi id 15.20.6178.033; Thu, 16 Mar 2023
 21:25:16 +0000
Message-ID: <655ac0f7-223b-9440-1bcb-e93af8915bfa@oracle.com>
Date:   Thu, 16 Mar 2023 21:25:08 +0000
Subject: Re: [PATCH v2 1/2] iommu/amd: Don't block updates to GATag if guest
 mode is on
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
References: <20230316200219.42673-1-joao.m.martins@oracle.com>
 <20230316200219.42673-2-joao.m.martins@oracle.com>
 <ZBODjjANx6pkq5iq@google.com>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <ZBODjjANx6pkq5iq@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR08CA0034.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::47) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|IA1PR10MB6899:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a1af813-e4d8-4c14-d9dc-08db2664ef91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H8DqgjD2AJ6hfVjFoFxhF2ZzFVvZMGIbduSl38FzsLDcoybg4Q4H5A8k3aX9CxvdwbXYZBjiO63CcfZQTc0J7jdqOdkWEyNAD+vYUO+5HHJJr3r+KIKxlZHlblb2iiwaab9qG+oCAb5hmRTIGTQS7zTN3UG98c2dA8TmJZHFMXaOqFH456uRbQZMGLYV8NYFz+3DBcUsaeIRQfvkAA/KZDsU5rguDftGecu9O8QzpKyMVuP0An/paMa5UkKRyFsNptMOo7j2e08ZeC89H5pYkFzdp7MhRLmrdfsNTDQ68p7Il5giXjvZc1iXWpKHCjsRfr4KyApjHnvJ0ynlvXWyGBybaP+g69mjJUkXFUDkV3fIopZUCOflcKKOz1ZP7OVINe0GKdM5YNdJBSFVz7iLvlMYag+8kaKFMy3TtG+Ef5nHhCyU94oqnmrlU0MIZcpIkCPZvbRXjG9dREjstWBgn+85BhEpEERq4VPl1B6ADYOql740CDDlDJVZREgrtaZ3YlVzfR0hNzbPVCKXFsA8XPy61Zy0lNkH5zH6tV8mGicv/mO5uGfdIMXealPLFq6p+/e0KeLYipM0bP7CgRDskE5E8483faC500GZnAdoyPjwfArK9PODXe2BwAOZETD5UM0Ss8QO7WrUrgqijntwEQnIjvcgS49e1EEnAqFcngTuRm4oWnUW+9yy+lgwlUHnH/IgZzluFGv6zzsxEym12A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199018)(31686004)(4326008)(5660300002)(53546011)(8936002)(2616005)(6506007)(6512007)(41300700001)(186003)(26005)(6916009)(31696002)(86362001)(36756003)(2906002)(15650500001)(83380400001)(66476007)(478600001)(6486002)(8676002)(316002)(54906003)(6666004)(66556008)(38100700002)(66946007)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dFJkZUV0a2x0NUdwNjgvZGJSTUlCZUVISWJpd0VScWIrWnJwNGRkWWxVc2Nk?=
 =?utf-8?B?M1VIa1kxREtmQjloZFVyWnFUdnA3dGFIQXhrWGpLOUIwY1VQTklnV0ZPcGhj?=
 =?utf-8?B?Q05RSnBETjFwdE0vZ2JwNjZlWTBJbm11cVkzdUNsYVF4Z0p4ZFRiTThMUVho?=
 =?utf-8?B?ZEI4MFFTTEwvSzlqTmg5OG5EVGlsTld0RU1UYlNFakxtb0JqRlMwbDhkeGtk?=
 =?utf-8?B?WHF4d2NZTFBGRUkrd1VRVklKaFZwOVU5dHA5YjNqcml5UjJXMjdWZ2JCTkx0?=
 =?utf-8?B?ZkpqdDlqdmd0UzV4VFdDR2dFWUl5VTRjSzJzaTBLTzZoOW1DWkRUVHYxS3VN?=
 =?utf-8?B?R1owTlQzSjhXM0kwL29ma3Z2ZXByWXJlUGUvanJ0SzJmL1ROMXpEWUJYdkQ1?=
 =?utf-8?B?bno5S1dqWTNBR09rL2I4Rm9NdFE3Nzd4VXd0dzR2WVB3ZDlwOExSVGJ6RW5s?=
 =?utf-8?B?L0RodFNpeUVGV284NmVpVWR0MHRFL1hrL0o2MUIxcUJNSzE3WXFCdEdOSzlE?=
 =?utf-8?B?aXlhdUtwZGZaelVrY0psVXAyWnFlK3NTQ1A2YXc3ckxON2ZyTUY0dHE2Rnhh?=
 =?utf-8?B?Q2VjTGQ5blFCVEV2aG9OckpaUC9HbGYvN2c2SW5FMERTNktKZld1RnRxVnFh?=
 =?utf-8?B?K2o1aSs2MUYzais3aElwVW5sdlZFTkNzYzJPL0xmcmRNMSswaFBwbk1iaUVi?=
 =?utf-8?B?WHVEK25YbmI2aGlDUkUxSWVzYWd0bXgvTitoOW5CcCtqblRJQ0JDNFlQd0ZJ?=
 =?utf-8?B?dmtXVEk0S0QzMlVNTVR6VTk5eGUwbUwwZkZqZXpZcy84QWhBQ2k0T3oyYXZJ?=
 =?utf-8?B?Ty9XN3hSbGlSbHdUOFg2ZXhzL21iUUozdG1NdFJMYjZ1dlhIQjU4MWkyWGtW?=
 =?utf-8?B?Sm5xWmZZUHlCNmVYRVRGNkNOYk5TZ05sSHptbHpqeDFsOVd3Q2hhS2JQZXND?=
 =?utf-8?B?a1EyeURvakpmU1FKcWRiS1QrZVkvQ0dCQlJxdTNlZjlVWEc1M3FRSkRoSThC?=
 =?utf-8?B?bjVENisvR01EVnJmODRMalBJWVNpOHlnSGJTZ1U4MlBsckpWajdWSTFpRnBS?=
 =?utf-8?B?Sm5xbm9zUlJuT1pKdGFMajJLL1VHNlVjV09hdzhud3lmUld1QU5VaXFlOVZa?=
 =?utf-8?B?OS9TNU5BR2oyNGRNb1QxbFdQdDNUY1VaYlpRNk1keHFjQmNoTGt1M2YyK0Rn?=
 =?utf-8?B?bS9YQ2xiQ3VwVFc5c2NkOVdkT3dPS1l6NGU2RVZVcmVZQ3QvaXJFN3VPaENq?=
 =?utf-8?B?NGFUWGRmQ09zQ2lqaFBOSVJ4cnl1VGV3cDIzTXR0bTBHY2ZpUnBIcFM3dDh1?=
 =?utf-8?B?N3k3Z0NJdDViSUFHLy9ZaEtpdE94VVlPcHhNNjJoWWFQNjVNNWUyM0laanJq?=
 =?utf-8?B?NlZoRCsyL1FNKzNyWEFzNFV3eVFwaVJxQlpoeGpDOHBha21CekkyMUVpQnUr?=
 =?utf-8?B?bHlXL1RZOHpVbkxLVyt2RkJDVDNBUHhsVkkzczdpQUx2b3pObS93TG81eDNi?=
 =?utf-8?B?OGlkSHFYQ3l4b3JvUmJnVzFhbkI1Tk9iTFcrS0xjVGJOYnlpUWFPZndwWGh4?=
 =?utf-8?B?Y3Z0bzdnMW5xSlYxbGJ5d2xGWWxwc21PdHVDV0JVNld1WTZQUDZ1aGdqN0pK?=
 =?utf-8?B?ZmxtL3dqR0x5c09WSk9JKzJGWVdrbytDcUs0ZmFRMWVNTEkvdmw5V2wybWZK?=
 =?utf-8?B?NVpjV01GalVxMzRWS0RUcWlnSWppdmQ5Kzd4eWdqVnprcVVhTnN4NTBxSzhI?=
 =?utf-8?B?ZDFmSWNhelFubHBpVTNmWGh6d2R5bGtOdTVDdGduNUQvdXVmOENreCt0cEZ6?=
 =?utf-8?B?Z0drY3lQN1F5cGxSblg2a1dRdTNwR202T1NsRHRxR0VqTlZ1YldxZzc3RmtG?=
 =?utf-8?B?azVlZ1UreVd5VE1nOHhLQXI5eE90SWx1eU9YL051cVlmL1k0S3pubElibENU?=
 =?utf-8?B?YS9zaUhxNjgyaE9ENnQ0Z0xhSzNGNWRxZlRpdy9vS0l5azRMcytCdlpETGVx?=
 =?utf-8?B?dXgvRmFabFZIS2pXMkxaRVA3VjBjNU9ULzREWkl3a0hwNXI3VlRiVDFXbFJK?=
 =?utf-8?B?cmNia3c5dXd6cnExYWcvM3UrbzBZa0pROFpGRW0vanVmMGpiSmtyS2pMbmlZ?=
 =?utf-8?B?YXk5ZEdhOThaRFVWakV4TkEraS83bU5GTWkxeVJDa3ErdUFqNUZIYW9yd3pn?=
 =?utf-8?B?NGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cjJMRXM1S25SQzZHZ0VPR3ZLalZzK2JZZkRQZXdLMEZ2c3k1alJwVzJITkpF?=
 =?utf-8?B?NGhuTlZpTlZlSjdRdXpNQkhtMmdFbFowZ3NKVTdBM01haytUOFRUbkJ0Y1Jz?=
 =?utf-8?B?akxVcUdPWHJUOEVTNU8xNGlKTmMydnBNaGRoVVdTQ0h5QnA1ZXRkN2F1WHNy?=
 =?utf-8?B?TUpwYTZYSHhxOTNTYzdML2JOcVF5VTN1dm1GcjFWWEFYaldEZnJaTFBmaXMy?=
 =?utf-8?B?TjhtdEF0K0tOb0ZhRUJCa2VrL2pLbWM2ZDVyZm5iZFNQZkdhMmpHcy9EcDBP?=
 =?utf-8?B?YmE4SE12RTdDczR4M2Y5Z3J5SHpnY3FWL2JhazN3OHNhM004MlN6eERXNzcw?=
 =?utf-8?B?MStycFFIcCsyQURHeGMzQjRMbG4yd3RmbEJXNFpLNERHRE1BVEVhQi9Ndnl5?=
 =?utf-8?B?SGo5Y001Q3VxRklhTUJJMGt4K1JSNXRyYXBRUldFZlBDNzJqOTVFUFNIT1E1?=
 =?utf-8?B?dEZmckIxbC9mTEExZEdEK0VIKyt0Rk43NDkvWGRoRmdOamNZOTdUWEVVaDJ3?=
 =?utf-8?B?NkdOUC9rQVovV2Z5WkJ5YWQ3T24yS0xyYllDaldSRXFiaHgzM1dZdzVJQXVs?=
 =?utf-8?B?MGlHUnBmSk52Zk91NFNzZWFIQlc1WG1xc1VMdDNwblN5bmt1eklNZGFPaFY0?=
 =?utf-8?B?c3pkQ25rK2sveFcxVG1zV2VmcU50dGVqaWxmd1BVVUw1OGhvWkRSSHVoeUNO?=
 =?utf-8?B?UUZJUEtSQlFQakZudDk2NkJ0bEtTbzVLeitIeVlqRXBLelBMTVg0VEVxSEto?=
 =?utf-8?B?WjFQdzBsSThIcTYwdVBublZpR1N5cEtOeXlXRnJYdkNwOGd6VXlwQlg4Z1Q2?=
 =?utf-8?B?YlhWMlFJRW85U0sxNjVpZ0pLVGZFUzJ4aGlCL3Nkek43U1lnUTZoWUNBb0N5?=
 =?utf-8?B?OUIvMW5idk5jTjlGbVZvT29IY01JUDNlK3JPU245TDRtV2NrUEdJRkFiNDFF?=
 =?utf-8?B?M1lFMEE0YXBjTW11YVplVVUwN2xjdDZhN1M5T2p1d3Z6LzJ0bzQ2NThnMkpF?=
 =?utf-8?B?Z1FoYmcxN0hZMWk0SFA5ZW1MYllLZWdFNDhidVRaRlNPbDZpZk9YSjhvZERU?=
 =?utf-8?B?M2U1WHZGd0YxVGxEamhMRWpJQzlaejUwSjk0ekJNdlNxWVQvckY4a2hDVVJ6?=
 =?utf-8?B?SytSeEkvQ1NyMk5RZ3Q4eFpYSXMxWGxnM216aVRkeittc0dHYjlQbC9YdENB?=
 =?utf-8?B?QWUwRGx4c1B6SXBYSXp1bmlacnFGbkNyanU2RzIwQ0NDK24rL3k5SXR6VWJ2?=
 =?utf-8?B?NFN5Smg0ZEk1YS8vYmFKZlkwbGZrUDZwUkxEdmZ4Y2Fyelp5Zz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1af813-e4d8-4c14-d9dc-08db2664ef91
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 21:25:16.4704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WsTfn7SoICffI0RmAE3WbI3++RvAeTDDhBwvf2hQrXIv9lmd04heU8/WOMloJT6jpKBlfYtQzgOnW2yZ8mvJ8vOKykmTlW4aJKYDoF+1lcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6899
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_14,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303160161
X-Proofpoint-GUID: 4QksA0vjwPqce7plX9og-BpTdaBB7WTf
X-Proofpoint-ORIG-GUID: 4QksA0vjwPqce7plX9og-BpTdaBB7WTf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/2023 21:01, Sean Christopherson wrote:
> On Thu, Mar 16, 2023, Joao Martins wrote:
>> On KVM GSI routing table updates, specially those where they have vIOMMUs
>> with interrupt remapping enabled (to boot >255vcpus setups without relying
>> on KVM_FEATURE_MSI_EXT_DEST_ID), a VMM may update the backing VF MSIs
>> with a new VCPU affinity.
>>
>> On AMD with AVIC enabled, the new vcpu affinity info is updated via:
>> 	avic_pi_update_irte()
>> 		irq_set_vcpu_affinity()
>> 			amd_ir_set_vcpu_affinity()
>> 				amd_iommu_{de}activate_guest_mode()
>>
>> Where the IRTE[GATag] is updated with the new vcpu affinity. The GATag
>> contains VM ID and VCPU ID, and is used by IOMMU hardware to signal KVM
>> (via GALog) when interrupt cannot be delivered due to vCPU is in
>> blocking state.
>>
>> The issue is that amd_iommu_activate_guest_mode() will essentially
>> only change IRTE fields on transitions from non-guest-mode to guest-mode
>> and otherwise returns *with no changes to IRTE* on already configured
>> guest-mode interrupts. To the guest this means that the VF interrupts
>> remain affined to the first vCPU they were first configured, and guest
>> will be unable to either VF interrupts and receive messages like this
>> from spuruious interrupts (e.g. from waking the wrong vCPU in GALog):
>>
>> [  167.759472] __common_interrupt: 3.34 No irq handler for vector
>> [  230.680927] mlx5_core 0000:00:02.0: mlx5_cmd_eq_recover:247:(pid
>> 3122): Recovered 1 EQEs on cmd_eq
>> [  230.681799] mlx5_core 0000:00:02.0:
>> wait_func_handle_exec_timeout:1113:(pid 3122): cmd[0]: CREATE_CQ(0x400)
>> recovered after timeout
>> [  230.683266] __common_interrupt: 3.34 No irq handler for vector
>>
>> Given the fact that amd_ir_set_vcpu_affinity() uses
>> amd_iommu_activate_guest_mode() underneath it essentially means that VCPU
>> affinity changes of IRTEs are nops. Fix it by dropping the check for
>> guest-mode at amd_iommu_activate_guest_mode(). Same thing is applicable to
>> amd_iommu_deactivate_guest_mode() although, even if the IRTE doesn't change
>> underlying DestID on the host, the VFIO IRQ handler will still be able to
>> poke at the right guest-vCPU.
> 
> Is there any harm in giving deactivate the same treatement?  If the worst case
> scenario is a few wasted cycles, having symmetric flows and eliminating benign
> bugs seems like a worthwhile tradeoff (assuming this is indeed a relatively slow
> path like I think it is).
> 

I wanna say there's no harm, but initially I had such a patch, and on testing it
broke the classic interrupt remapping case but I didn't investigate further --
my suspicion is that the only case that should care is the updates (not the
actual deactivation of guest-mode).

>> Fixes: b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> ---
>>  drivers/iommu/amd/iommu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>> index 5a505ba5467e..bf3ebc9d6cde 100644
>> --- a/drivers/iommu/amd/iommu.c
>> +++ b/drivers/iommu/amd/iommu.c
>> @@ -3485,7 +3485,7 @@ int amd_iommu_activate_guest_mode(void *data)
> 
> Any chance you (or anyone) would want to create a follow-up series to rename and/or
> rework these flows to make it more obvious that the helpers handle updates as well
> as transitions between "guest mode" and "host mode"?  E.g. I can see KVM getting
> clever and skipping the "activation" when KVM knows AVIC is already active (though
> I can't tell for certain whether or not that would actually be problematic).
> 

To be honest, I think the function naming is correct.

Part of the problem here (as you also hint) is instead the reusal of the helpers
used in the (correct) transition to/from guest-mode *externally* by callers
mixed from *internal* usage in amd iommu code for IRQ vcpu affinity using the
same said helpers. And that'a also the reason I put the Fixes tag as that patch
introduced such "reusal" and which could be useful for stable trees. Here we are
mainly concerned with the updates (the internal usage) and actually exercising
the IRTE update instead of skipping it such that when you have interrupts on
blocked vCPUS that you actually wakeup the right one (and not doing so has a
rather drastic effect for VFs within the guest).

>>  	u64 valid;
>>  
>>  	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
>> -	    !entry || entry->lo.fields_vapic.guest_mode)
>> +	    !entry)
> 
> This can easily fit on the previous line.
> 
> 	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) || !entry)
> 		return 0;

True, I can move it to the previous line.
