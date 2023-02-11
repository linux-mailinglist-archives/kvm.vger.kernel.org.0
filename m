Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F213692EF2
	for <lists+kvm@lfdr.de>; Sat, 11 Feb 2023 07:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBKGwh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Feb 2023 01:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBKGwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Feb 2023 01:52:35 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A851F196A3
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 22:52:34 -0800 (PST)
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31B0b4JF009732;
        Fri, 10 Feb 2023 22:52:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=aua7/9aKNBXqfR+wTZAjlJtVY+f607jgGJWylP0kDbc=;
 b=y02z2kL16S52n9OLe+KTxra6sz0K+Fqi5O/ZXI44PkYqsl9V5oDCSlETH8I9mhO0HJnV
 Swbxh0zYstGvBZ+e24VE1G+NO8+BwW/u465F+goT3wF3HR8bzPk9lKtVHLNQe6Xi4/Pq
 VZ+oWjN0KhKYgJFte9qjEfxQk1l1FAI7H6oMYo4HMo6q5/aHTgCKBMmajS6JaWE5W5R1
 bX3llWWjpLUDRVVgWowddFKqNPrI5/Z5hyRNjWq6/tN8O4QLLGeMwb9uBzOK3S7JGEQs
 qPglcBaQdx6n/KsaqULHvSUX/C8i3dOxVkdItVoWDoDCHOk/7Gd5k0Xpm8091K3OVGqD /A== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3nhm5j5gd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 10 Feb 2023 22:52:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SV+YC7gsf8WorDYYHBgKls6dV4WmucV9qFGtEDQZm6HkRneyHCociyS9MHNEfRBrc3TyJqO42/DpzUxEsD+0YN7HaYaudXrw9az1ljy/kyyEBtQWp41Nt0vOJwWlXGNNynNT/6+IXAFFRZM9pCAxc2I/freoZKUVKVc/XZ5s3yJRWZXJJTfjNo9Cy+ic01fZ2bqJHlyofJPjclWDkc/JCNdrwwy/nIJK4m+IOf0HBwxA1B2AGi8XH1wfB+3ie/jILIwzAdFsq88U3/9ET6hKnnVAFK3liJdyAp23/vPjTMXDYDVcqJJ1Ul4E1HA3otFZq3lriuhTwQWDrkhUD6HonQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aua7/9aKNBXqfR+wTZAjlJtVY+f607jgGJWylP0kDbc=;
 b=HubHF8dJmMI4I/sjj+Zj9UmUeQmAaKaxJJ91vvv9I0WPyEV8CJqrsxeaViP0bKpuKQ/GAWO72ku4CeYEpqmNe9mfNcaJ+UGz8I9T+m0geIo7x+rRfF+Dm2orWj1LrIYKbnEoPtH+YuRVPEZSf4HMWpI6Q/a/mMRphnGvIcHVVyhhzN32SOh7aJq8/eW9sjxx9D7F/7izirFNxp3+piau07s0F1THJt+elHk+y7BWIcv0xkcoI1TXOF6RDMs+koWISbEtq3zB24qKIjI/J6s6t7HU/Ncbl4JumuxB7YcCAY3TnZaM9NYCei3NHBnvgy+8Wu+g4GUaBNTTE8Y3Jsgirg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aua7/9aKNBXqfR+wTZAjlJtVY+f607jgGJWylP0kDbc=;
 b=zLE+tp3hwqolofvkS2pre30ic7UySXOOlsfIUnMHKCAN8m7STX4ZEwvMACvPsCMLL6V5BEvDGvt4UPfKAz+kfHCgasAgFR39Ghd7Qs+XC/fR5oGZoFzrjbtddVYehQ7aqOPTmC6bPsToeddUcB+WHLHsbcguGsWgq2mh2Lj9MGaZ1jHSAk6rTHbopfKNYu+F1OZZZevNdI/OV5P0BRRMDIUwv+RP0xx1i0GIjy/+joAc1qIHub+veoRPGOXbTc/AVSpx28tr6iUpYqX+zarNllIOEhcDxOsh4fvrgWL7vExgCkmD0FeKB/n5m7+/JlXTW+9D5jIO1U3AiAbM+xLSsw==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA3PR02MB9309.namprd02.prod.outlook.com (2603:10b6:806:316::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Sat, 11 Feb
 2023 06:52:14 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%9]) with mapi id 15.20.6086.022; Sat, 11 Feb 2023
 06:52:14 +0000
Message-ID: <200246c2-9690-dabe-279e-13bc9beb711f@nutanix.com>
Date:   Sat, 11 Feb 2023 12:22:02 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <86zgcpo00m.wl-maz@kernel.org>
 <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
 <86mt8iopb7.wl-maz@kernel.org>
 <dfa49851-da9d-55f8-7dec-73a9cf985713@nutanix.com>
 <86ilinqi3l.wl-maz@kernel.org> <Y5DvJQWGwYRvlhZz@google.com>
 <b55b79b1-9c47-960a-860b-b669ed78abc0@nutanix.com>
 <eafbcd77-aab1-4e82-d53e-1bcc87225549@nutanix.com>
 <874jtifpg0.wl-maz@kernel.org>
 <77408d91-655a-6f51-5a3e-258e8ff7c358@nutanix.com>
 <87r0w6dnor.wl-maz@kernel.org>
 <4df8b276-595f-1ad7-4ce5-62435ea93032@nutanix.com>
 <87h6wsdstn.wl-maz@kernel.org>
 <8b67df9f-7d9e-23f7-f437-5aedbcfa985d@nutanix.com>
In-Reply-To: <8b67df9f-7d9e-23f7-f437-5aedbcfa985d@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::17) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SA3PR02MB9309:EE_
X-MS-Office365-Filtering-Correlation-Id: 70d87fd1-a88c-4933-5d8f-08db0bfc81c6
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: piH4brtlDcP5+T5JLO7itd6XnMXrgRrGEwm4VqALX8ehRYlE5gUkZnxxBXSzyEYcPDQGpeyoPpuXzzoKXQsxXI2wBbxrBMzd5MdeP5OhUjWVMa6wgUqgr2sKmlUTZDSruZAOOXaufK93fp0u39sjL9zm9e7LcUQyLa6DGZDEVsu38LeJUA/dRWm2ftLr7KDt6ji/cxx5FmEW1XY/ISv79ACybtkk5U+UXbG2cFF9/tTyRpYiJfdXNgOkAcvxA7xcjwtuW6qze8U+tJJgfyzz7re8aqaq6QhZbrzShN5WlGDpLkLrgsmtdEB5JQeZulr2jpidxW/Wl40ZwVqYY+CmaqHoYi9NlYUSCykt5OonoDxXPQggTcMYBpjXOdKKn20aNbWSI+pCZ+oUFBb67qDD5r9pWRJDAOwzQKv1OME0jgOpbi5huUBXJbvy/jTKBBqbrOqOTl6FsbEce6r35IZdy5I3OOXdMepwxDz1Ex9XpNDZc7l36adVz2Gi+RiDTWDny/Qc/8aDlY/SdCjvEMjQJDlJ7U5pKRpyvQMhBnCmcdtxjdP+Tzw45LPnrbs/rWLwZp8LwOG92XFHLAY8mLu8l2H+IJ9NA6cMHfVhiXj3s/v3eo+9dk35OMzrxWZzgVOKHyWfU6yRFmpKGQx5r/63on6eFvtrwIZWvSD9J43rgA/g9rJEVQi4+t8utxKeN4BvVZCi3WAM/aO+ngDThAD5xz4FD2sO0GLaqbSDPfoH2C+GCmxtBYh5ubtIUySU9KiP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(346002)(396003)(376002)(451199018)(83380400001)(31686004)(6666004)(478600001)(6486002)(107886003)(2616005)(6506007)(6512007)(26005)(186003)(38100700002)(86362001)(31696002)(36756003)(66946007)(6916009)(66476007)(41300700001)(66556008)(8936002)(316002)(54906003)(8676002)(4326008)(4744005)(15650500001)(2906002)(5660300002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVZhWUxIU01ZcmZxblc2eEhCOUkzRkFwdEd0ZGliWTRVandzQzYvMjNSbDUv?=
 =?utf-8?B?T1VLdW8vd1ZGaHVCUVY5VWk3M3h4RjFCRFBBVVpwKzBSSGFad25FT2V1YVQv?=
 =?utf-8?B?SW9HTGg4U3pUd3NxQStGN0tieDNFdmM0YkMyeFQrMWhTZTBGaUFTYitRbHlD?=
 =?utf-8?B?dmgxdGRsZnEzenBBTzIzWC90ajdkbFdrRDY0Ri9ERmFIM0JEMHVnVXkraUJO?=
 =?utf-8?B?QkpMMWVLajNjVnBVSXdrSU85elc0RTBWSEVZTUpPR1JtNUErYUpZR1k0aEYy?=
 =?utf-8?B?NUhKZEc1aFBwVE1pWHZKU24zSGNaQ1JqVmd0eTVFcTczOS9NQzZmOHQrZG51?=
 =?utf-8?B?WTZOSzJVdGh5OTNLTENTM04xMU9nN1FtcXdTU2lrODRuZklFUzd4MUpqSFQ4?=
 =?utf-8?B?ZDZiMllYWEYzZVJ1TDJBTE9rWXd2UGpIeGh2TEl2NjNRT0dsdG5UTXV0SFRK?=
 =?utf-8?B?SjlCL21RSlFybEFhbUxGK3EvS0Y3QkluKzZsVFdKRTcyejBhQ3ZlbE1weWpF?=
 =?utf-8?B?eUVjSWlZeXRzV2JZc0lPQkd2T1I2bGV3M253VHpxQWRPMlptN0w3TnNhaThs?=
 =?utf-8?B?dWZnNHZmNXNxOVlPeU5TMVVwY1pOakdZZEl6eXNPaVlGMk1XSFpPcDQvbExC?=
 =?utf-8?B?NkNiZkNxdExzSUNQL1BuZVN0cWp6TWlpMEVFc3B3M1NXK3VsWFF6aXoybkJC?=
 =?utf-8?B?eUJxNVl0eGtyMTlPdXZpclNpRGp0bGtDbC82RUMwZXR4c2orc2xOVGxQYWpv?=
 =?utf-8?B?TVBXMnlOL0tIWlgvdFJjbE1vcC9HRmdWdUlnRE84dENrVjVSdjdyall3Y2ph?=
 =?utf-8?B?NjdOb1luaUtGVDFIZS9kZkJKL0RmRktaV1V4Y1FoQnJkcWNlQzNCQzRyQVlB?=
 =?utf-8?B?eElKT1VyZWFWcEp1Tm1nNkhQQyt4SW5kSzFLOVJQK1UyRndpQnpQZXhUSDM5?=
 =?utf-8?B?NUVONkhrbjhSMVlzVjVXWDlTSlBYb1cweHJpcmlocU1GYS9tak9lOFA4Q0Rk?=
 =?utf-8?B?NURvNk9KQk1WZE9JSnNJVkdyZi9LMVd2T1pNeHkxejNoQjhlUm92cFRqMmtz?=
 =?utf-8?B?MW1zdVlIN2hYQVVCMnRodnhnb3E1QnBFa3dDSm1NcFNJVFF5TjBMZWlRTkFJ?=
 =?utf-8?B?OWhKOHp1L09ISmV6OGJkblhpNVFOUkNaZDQrRDJaYVZNQnUrVTIxQWRIWlAr?=
 =?utf-8?B?bnhGMWh6ZzI3R01veEhQNzFQdEo4U2xLY2tvRWNHNno5WEN2WWt6dTNpSTAr?=
 =?utf-8?B?R0Z2WExJRmc5R2tMZXNrVmgwQkhrZGpaTFF1YXUyc0FRNVNqMDNscVovRVZy?=
 =?utf-8?B?amo1amVBY1cyOFV6ekVrZmJkblQ3QmdsbS9EbXpPNlJha1B5Mm5UczVsK05l?=
 =?utf-8?B?aGcxcUFMMUhCQkc5cW8zN0tFTkh1NzVvajBud1RjZjA2eGduTUk1eFFTV2tj?=
 =?utf-8?B?Tm5LQzNKWkUxS0VIRGFtSFpzN28xTk43cUxTZGF3amViemhnd0xWU3Q5Qk82?=
 =?utf-8?B?OVYyOTg5QTJZeHlkYml1NU4xRDhMdFBwcWVIMGRQWFRnYlpacUQyS0xqU2Vs?=
 =?utf-8?B?Q2Q4WGoxRU1vT0hEWmR1cU43cnM4ZzdHNVhtb3JXZkRqK1BSbnZNMGtWY3Bv?=
 =?utf-8?B?bTdURCtiVW1CTTk4NnBxdGNmUFJkVUhNbWNNTWtYelpPb0ZpdS9aK3Fpd0xl?=
 =?utf-8?B?bEVxNkNqMUZmSFY0TzRjS1VCUE1TRC9HR2lSTGlOMGZIbTlHMVJ6TDdzbTdH?=
 =?utf-8?B?RGtBc1hmOTh0dE5uZFJ1d1MzUnFTelUxYXYvSkxZTGk1MUZKU2VGT2xYbEVU?=
 =?utf-8?B?ZG03NnFJdUo2S3lqRFZ1SXBYb2ZQQTRCbU9BektkcDdveXZtUHFEZ0VyRXNz?=
 =?utf-8?B?bTUrYTg4a2ltZTh0enhKOTlmUWRNOXRzSHRPWkR3VUNuS1F5aWlsU2JrSWwr?=
 =?utf-8?B?QWkvVzltWjdNVzllMk1RSHVUOGxRUUMwZ2ZjSm5WUzNKOU4wS1FPZjE3bWVn?=
 =?utf-8?B?MU1SbzQ4QUlDQjg0QTZnOFI0M0xFT0ZlclNRbmxKUDhhS3RVeDV6SFJWMnMw?=
 =?utf-8?B?dk01aU9CMHBRc250ZWpJZ2JOWlZXZTNaSEM1cytUNmpWNnF5RGFFdHd0UjNG?=
 =?utf-8?B?RWdKMkFRTDlvR0V6WE1Ha3hETHlwUHRsdmJXendUUy83YWlPdjhkcWVvdTJ4?=
 =?utf-8?B?Qmc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70d87fd1-a88c-4933-5d8f-08db0bfc81c6
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2023 06:52:14.4369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B4KJZ0eJtz5fSfymSL+Or4DHaXrmcCTJhl65F5WBnfbDX/q9jGxIFB0WXDk4OQVkr3bKt8/5+PlJxlTPJkGbMc8UQMXF9X2hGqXcb+N5Mto=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR02MB9309
X-Proofpoint-GUID: o3jdky4IXchDikVPkd2dRGquzPWIpFcc
X-Proofpoint-ORIG-GUID: o3jdky4IXchDikVPkd2dRGquzPWIpFcc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-11_02,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> Hi Marc,
> 
> I'm proposing this new implementation to address the concern you raised 
> regarding dirty quota being a non-generic feature with the previous 
> implementation. This implementation decouples dirty quota from dirty 
> logging for the ARM64 arch. We shall post a similar implementation for 
> x86 if this looks good. With this new implementation, dirty quota can be 
> enforced independent of dirty logging. Dirty quota is now in bytes and 

Hi Marc,

Thank you for your valuable feedback so far. Looking forward to your 
feedback on this new proposition.

Thanks,
Shivam
