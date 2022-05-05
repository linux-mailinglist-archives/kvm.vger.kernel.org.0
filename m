Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BED651C3B3
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 17:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236108AbiEEPVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 11:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347238AbiEEPVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 11:21:54 -0400
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6043F579AE
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 08:18:14 -0700 (PDT)
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 245DxEnj022460;
        Thu, 5 May 2022 08:18:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=rODn0vqp+thXFCa4fhERhXz9CdfirNbVSStDnIPpplc=;
 b=rgbk7A2y0Nxpit7MQB/Bpzr6LeXe+3gtbCkIRgtV3jY/1gj429u8qxEJY7CNsBF9qkGQ
 KA/S9hGhKLV5gJ2nvzfS6+T/IA8DLJUejjC+IpKkHSe4kV7w0gztu7F1IUasXgytrDw+
 o/ZmDnskP+xLclnh19GCMLbQD157XFxBTV9sVuxZ5oaKOVxqTzAyoK0EFFkkgFG0nKiX
 vfzLlTnY/XSh1sWG/9iu32fiDd3wEUgjcjGS+fpfO4NE4TBWPl/KgoAS0y99dGrxyFRR
 3DcRhVhJ+kGPH5gs4aFuKxRGjI5Z21JJH+Khue8LBpyay+4eLVPdF577STYoazsZSFZB 6g== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3fvfxv85sr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 May 2022 08:18:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QW9zRZTakz6AXgr9EuEyxAvbdAipCIvjTxGhmvmIrtYTUYE+wh3ScHO6oMhZ8hpz1OYqh0pbA+e3AUZrT5lT7V6XLmA/sej996DuAIE2iiGyHYNrOeZ69byYnBowEoWQiD+9qGvsDEudGtdQ5cSgcnYMKGlrL5AgJkJxnCliALdaeKtUXS78ePDzJs0sQk5SU3FnAXIPXoJyTO7N1TMn9OFcHIpkVlmg0qI6uiC1iGoplRYJPhmI1GbTn2mX/kys39Cbs2ekP9LhGlLsGR+dP5kJkgDidHUIbkxCuo/EGrcB+DCHK+7wQGKBwFfH9g4oFOmIHR1X6zOZbKuHp7o0BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rODn0vqp+thXFCa4fhERhXz9CdfirNbVSStDnIPpplc=;
 b=Av+SWKvk/sKXQhCnxi/GBPcDTmB8R9MuN77YmJPtlF7dH83alEG0FNpgP2dNnVdN6Ba8VTyxFunMXK9XFgY/WuJEk16J3JLju0iMipljTG4yEfVzwLhBA/J/+BDzgS3r1tKxyIByOOGETlI5hDanUQcmFUvxE/+p676+Sd230IS3xAsdQdLW1xsfNvqfNnsUPMxBa51XvehOrecV8rLshaSgV2SWDweXUS2Sp8VaARx/Icp8bXHU6HWMxC/sJucCCJe6kRefy7DASdZmqTbL914u+ZUy0a0S+ZLfLlnjdooJ2FKeuYjxm/Pyy+r2cbexymKRDCzMzhbTtbG6a/okSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SN6PR02MB4303.namprd02.prod.outlook.com (2603:10b6:805:ac::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Thu, 5 May
 2022 15:18:07 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::6819:797c:706f:9a01%5]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 15:18:06 +0000
Message-ID: <470cb690-cb47-234a-2a04-b048d4ee943f@nutanix.com>
Date:   Thu, 5 May 2022 20:47:56 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v3 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
To:     Peter Xu <peterx@redhat.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20220306220849.215358-1-shivam.kumar1@nutanix.com>
 <20220306220849.215358-2-shivam.kumar1@nutanix.com>
 <YnBXuXTcX2OC6fQU@xz-m1.local>
 <8433df8b-fd88-1166-f27b-a87cfc08c50c@nutanix.com>
 <YnExg/3McGZK3YdR@xz-m1.local>
 <25888a8f-ef44-ec69-071c-609ddd7661dc@nutanix.com>
 <YnK3RCW3RAMhDY2d@xz-m1.local>
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <YnK3RCW3RAMhDY2d@xz-m1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0061.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::23) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f299952-2451-4da3-9486-08da2eaa74b8
X-MS-TrafficTypeDiagnostic: SN6PR02MB4303:EE_
X-Microsoft-Antispam-PRVS: <SN6PR02MB4303E33631562376A13E12E3B3C29@SN6PR02MB4303.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/PpfLnBqcbapwXIO/pMm8D2Dlm0xRaiHmRrYExZF2oGCcEIpgv9s/NBCs0oosMtby5Q+P27FGgAgFl2VT0+w6yzHc5m5nA6jZvV6+kPGGr2g0WpZmqkUkqz7vYCQWLOtTJx5n/upzQqY4juPz8Nx2cWpqexMoSOef0E1gM5T1gN5e2g7OEf0J0AR9EIoHqy5O+TI0hHR22RkDe8BPBf6Q0MG6Y/V4sQjJH+UWnqih+vtasm1YSPQTijGQxVliK4nJYM+fQZcVJG9VZmtnrXz3lFoImjdOx2McFzYHnvRfcOEasE/V9tgDrj3D+uFvVVHX3VuWsw4jl0aMxeP908V80V3AGjTt/dsFkRwOkAlPUYQSAz9EiYKtxVAGNVsxDF86P8wOke49M85d3NKYa2Sp7pXDLVfx5mCDkgeyNrFqkAvm4NcSQICuoaHOXqem1fHIutlXx8LgORRnImzwMbDXky8zG+VJ59Jy8Q69Ss2LCUg1fP0dRBJFpzKCo1GDy7P63ib9APZgmiN12CasKwHZgWovuaiRwOThnJ4/oxI/SJ0h2ZbYiX4AYROa2LgKmMyAM1/QyhF44kVTXiSBco5Wv8+KJ1al1kQq/d9DpGBsSCf3RstMMgr3IBUlWHPf55noQx+76bMKXu9c3+5zKRnBlj0uZa7xTbYXOUF8ny3KcMD1zMHLe1D4Cg0ZoGWM6TmchatI0lzt/XyP9N9LTMXsbkZQMpeWKl8gR4d7h33D8/pXNbrrFsysb2E9UdWxr1cKnb0+qac4kNICnu47h/BIEF17b6q3zFpnfcVAx/IEfUQmTxSHGOD2RR9RGH8lQ00YLtkba7cq+9W0NpV4iZkW5Y3bQAwHzSntkdBVSH57jltS+A14tQTh7IATIuxGzC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55236004)(53546011)(66946007)(508600001)(186003)(2616005)(107886003)(8676002)(26005)(6666004)(6512007)(6506007)(66476007)(4326008)(38100700002)(6486002)(66556008)(6916009)(54906003)(316002)(966005)(83380400001)(2906002)(86362001)(31686004)(31696002)(5660300002)(15650500001)(8936002)(36756003)(30864003)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDFJd2cwUDVQemZYd2R1NHFORFBEWjRib1drM212VklXZFVEcmUzU1R0OXZZ?=
 =?utf-8?B?SDQvMitBOTJyMmx5VnFFSktXaWhuNzUrR1JpN1kyTHIyNFdnQlp3ZHVJMU1H?=
 =?utf-8?B?TDdnVkltWkt4TmtadVZUMzJySGhvTGsrM1IwdWU0c0hlUng2aU1HMkFrSk9O?=
 =?utf-8?B?YTV3WWdJWmVDYWhkMm9wQThydHZoK0J0RElJdy8vK2FTZlM0ZnhhalZmTFpI?=
 =?utf-8?B?bnh3M2VYMzkyZyswSVkzek9YejFSM0Q4cDA0aWl4TmlSL2xmWExLemtFSmNO?=
 =?utf-8?B?dy9OQ2k1cVFQYkFmSjRJZ1dTZnlZVkN2ZUwzbm5zY2pzY2VIb3IvcVNNZFBP?=
 =?utf-8?B?V1NGUU1WMTlsTTNkQjJpRFVuSUdYRnRrL2xxd2tyL2UraGtJazJMcWNNdzE0?=
 =?utf-8?B?NGpvYytodEtwTm5mckRxUnFkYitSZ0xXUWw3SGJEdmphV0I0YTRwTkFEV2Rl?=
 =?utf-8?B?SlJRaWxOcnlLa2gyVXYvODZkMU91RERPc0RWWEx3NjBzS3BUekhpandsR3dE?=
 =?utf-8?B?VVVQTlIwWXdSbTdLeTdKa09CZUN3MjNtUjVFRHNnZS9rMFFKbG1DQTZLTGtB?=
 =?utf-8?B?R0lreUxjQjBkVFN5dGk5b290WTJhWVlUU05GZWFyOGNIMlczSXlCSmRzUEZz?=
 =?utf-8?B?dTMrT3UvbnpwSnB0ZTMvUVo4NU5VMFN5UkZiQnV2aVJOVGtvOXdhSkNWWWxM?=
 =?utf-8?B?ODhJSlpQWTdoOUNDd1BQZEcveVExOUFjbFpzZG1FcHFmT2EwUUtBY280aTJ0?=
 =?utf-8?B?dnRqek4vM0Z4V3IvMDBqTytTbms2UG9UaUxaWnZSMHBSTGpVQldubHFoT0hw?=
 =?utf-8?B?MmMxQVVrUzV3aGQzVUQ0Z3JjSUJscVRHUDJpUUlXZURCQjZJNXJrN1M0ZElt?=
 =?utf-8?B?S0E2OGFkdzBVQThmVXAvdGxpY3h4Y3BnVjNuK3I3R04rdndqS2V4ckFlRGky?=
 =?utf-8?B?YzFMS2F3bWw4V0M2anZoczNENGhpQzkxTjNvQ1dtSmFuaWdkRFZteFRCSDBv?=
 =?utf-8?B?TzFPY2xSa0t5OHYzSHNFZlJDdVZqMUpKWkY5SVZhNGlrTnVGUHB2TTNFdzht?=
 =?utf-8?B?RkpVdDNwV1UzZTZHcVQrMmFlK2R0UlVKakIyaGtGeWZPL1UvRVRJR3ozMGFO?=
 =?utf-8?B?ODFWa2lodzA1T2hKNTJJU3FZamdQZUZjT1BMdDRlN1Q2Q0pkZFE4RWkwMTNS?=
 =?utf-8?B?d0Fobk1tTlZWaXhiR0xwVUhEVWVvRml3R2dmdkVFbGM2UVpCRXQvNTVvL0oy?=
 =?utf-8?B?UncxTm5BRkVuV2x6K0tDNXEvU1lFaHJua1Nhc2RrSUJ1MVBYb3JOMkd6Z3Nt?=
 =?utf-8?B?RWNoTDh5U3lTTzNvV0M1THRrV2Z3b0dkN3Zuc0hoMjd0L3hrMTNZdm1RQ0tN?=
 =?utf-8?B?VlpFZ3pHTzU4Y3IyeGpqUUN2WnQwd3Rid0dYY0F6ZEZ3RS9TRkdsWUZQYWV1?=
 =?utf-8?B?MlYxM1pFcHlPV3VYK0lkdTg2bVF6cXVja2xEU2dVRDIvYkIzUWlUSnVoNVRw?=
 =?utf-8?B?RmRqOTdwUjc3UWhrMW1hRDg4WEZNS1FkSlQ4SjJlejFrSkJML0l0aWxXMEYw?=
 =?utf-8?B?K1IwaWM1VnJjVXBDdG82d2FrSHBjT1R3OEZCSnhtRUNPTGlkL0RiUWF4MWQr?=
 =?utf-8?B?a1o5Wk1Zci9EWFFzWk1TRnJtdVFGb0lyWDdZN3ZvZjFiVFhzcDJ6bEtlTFI1?=
 =?utf-8?B?YkZzdmxDcXU4QjI5K1JPcytDdnJPNlpTRUdyREtsRTNaZERZVEhiZEVmamhE?=
 =?utf-8?B?SjZ5cDhSU2ZOWEJiNEtvdHY0ZDNvMlYwc014b2s2aGEzSUkxandnRU9LcnJu?=
 =?utf-8?B?Q0hNZDQ2WlRxd2t3QmlvZ0hhNUFNcDRBM0NLTldWeVozQjU1MDZPejJTVXFE?=
 =?utf-8?B?NHFPRFpIMForUzI3eFUzNXlLdGdFUDVJZXdsTUdRSmcwTEVTSGVzeVc1Rlh4?=
 =?utf-8?B?VVVNYXFKU3VOclpvQytod0RKQ3Ywa3pBV2s5cVRoajFpRXh1d0U4VVZjYmlP?=
 =?utf-8?B?WC9RMUVKcjl1bWRCWW0xN3ZwRVo1VU51b0JVTlZZdExuTHdVWVVXekJUOXFK?=
 =?utf-8?B?d2NXWnZjL3Y3a1V5MERDd1F4MGlPc0JvSkVXMVhZUUoxczBXbjJyN0FmMjhB?=
 =?utf-8?B?akJmN2tnS09QdExveUwwc2FCV0tGQzZaU2NwQTNLUEhRSGZpNHVWMzNNdDA4?=
 =?utf-8?B?amRDdlNxQ1AxU0tuMVhvbW1VZUl2RUFiNVpoQXB6SWo4QzBBd08rbTg2TTdw?=
 =?utf-8?B?V1N3dHp3VUc2LzFLRFVzUEVZWHlDdWR1ams3ZGx5cElGUjQ3R3FKaVQ1VWcw?=
 =?utf-8?B?ZlBMaFdWUHJDOGNaaDV5MCtHVUJFMW5FU0g0SWd2WTlBMUVrdlN0Nmg3OEdv?=
 =?utf-8?Q?4CAP5QjMZuMPGKU8=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f299952-2451-4da3-9486-08da2eaa74b8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 15:18:06.5651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2K2CxR71+L/v0iGtwwMXQSEyMPb9Yj7/WUiW3fjtCWGPXDfE+lY9w6UkeQ7CB6SClisNz37DqMYaIDlCQCAob5hFj2QAklzuqNTragxY6c4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB4303
X-Proofpoint-ORIG-GUID: oOYhpIU7zS_LkWLxovrbAol4-2m2fjrn
X-Proofpoint-GUID: oOYhpIU7zS_LkWLxovrbAol4-2m2fjrn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-05_06,2022-05-05_01,2022-02-23_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 04/05/22 10:56 pm, Peter Xu wrote:
> On Wed, May 04, 2022 at 12:03:57PM +0530, Shivam Kumar wrote:
>> On 03/05/22 7:13 pm, Peter Xu wrote:
>>> On Tue, May 03, 2022 at 12:52:26PM +0530, Shivam Kumar wrote:
>>>> On 03/05/22 3:44 am, Peter Xu wrote:
>>>>> Hi, Shivam,
>>>>>
>>>>> On Sun, Mar 06, 2022 at 10:08:48PM +0000, Shivam Kumar wrote:
>>>>>> +static inline int kvm_vcpu_check_dirty_quota(struct kvm_vcpu *vcpu)
>>>>>> +{
>>>>>> +	u64 dirty_quota = READ_ONCE(vcpu->run->dirty_quota);
>>>>>> +	u64 pages_dirtied = vcpu->stat.generic.pages_dirtied;
>>>>>> +	struct kvm_run *run = vcpu->run;
>>>>>> +
>>>>>> +	if (!dirty_quota || (pages_dirtied < dirty_quota))
>>>>>> +		return 1;
>>>>>> +
>>>>>> +	run->exit_reason = KVM_EXIT_DIRTY_QUOTA_EXHAUSTED;
>>>>>> +	run->dirty_quota_exit.count = pages_dirtied;
>>>>>> +	run->dirty_quota_exit.quota = dirty_quota;
>>>>> Pure question: why this needs to be returned to userspace?  Is this value
>>>>> set from userspace?
>>>>>
>>>> 1) The quota needs to be replenished once exhasuted.
>>>> 2) The vcpu should be made to sleep if it has consumed its quota pretty
>>>> quick.
>>>>
>>>> Both these actions are performed on the userspace side, where we expect a
>>>> thread calculating the quota at very small regular intervals based on
>>>> network bandwith information. This can enable us to micro-stun the vcpus
>>>> (steal their runtime just the moment they were dirtying heavily).
>>>>
>>>> We have implemented a "common quota" approach, i.e. transfering any unused
>>>> quota to a common pool so that it can be consumed by any vcpu in the next
>>>> interval on FCFS basis.
>>>>
>>>> It seemed fit to implement all this logic on the userspace side and just
>>>> keep the "dirty count" and the "logic to exit to userspace whenever the vcpu
>>>> has consumed its quota" on the kernel side. The count is required on the
>>>> userspace side because there are cases where a vcpu can actually dirty more
>>>> than its quota (e.g. if PML is enabled). Hence, this information can be
>>>> useful on the userspace side and can be used to re-adjust the next quotas.
>>> I agree this information is useful.  Though my question was that if the
>>> userspace should have a copy (per-vcpu) of that already then it's not
>>> needed to pass it over to it anymore?
>> This is how we started but then based on the feedback from Sean, we moved
>> 'pages_dirtied' to vcpu stats as it can be a useful stat. The 'dirty_quota'
>> variable is already shared with userspace as it is in the vcpu run struct
>> and hence the quota can be modified by userspace on the go. So, it made
>> sense to pass both the variables at the time of exit (the vcpu might be
>> exiting with an old copy of dirty quota, which the userspace needs to know).
> Correct.
>
> My point was the userspace could simply cache the old quota too in the
> userspace vcpu struct even if there's the real quota value in vcpu run.
>
> No strong opinion, but normally if this info is optional to userspace I
> think it's cleaner to not pass it over again to keep the kernel ABI simple.
Ack. Though this implementation path aimed at not reserving extra memory 
for old values of dirty quota and making the solution robust to multiple 
changes (multiple old versions) in dirty quota during dirty quota exit, 
which is rare. There was no such strong reason.
>
> Thanks.
>>>> Thank you for the question. Please let me know if you have further concerns.
>>>>
>>>>>> +	return 0;
>>>>>> +}
>>>>> The other high level question is whether you have considered using the ring
>>>>> full event to achieve similar goal?
>>>>>
>>>>> Right now KVM_EXIT_DIRTY_RING_FULL event is generated when per-vcpu ring
>>>>> gets full.  I think there's a problem that the ring size can not be
>>>>> randomly set but must be a power of 2.  Also, there is a maximum size of
>>>>> ring allowed at least.
>>>>>
>>>>> However since the ring size can be fairly small (e.g. 4096 entries) it can
>>>>> still achieve some kind of accuracy.  For example, the userspace can
>>>>> quickly kick the vcpu back to VM_RUN only until it sees that it reaches
>>>>> some quota (and actually that's how dirty-limit is implemented on QEMU,
>>>>> contributed by China Telecom):
>>>>>
>>>>> https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_qemu-2Ddevel_cover.1646243252.git.huangy81-40chinatelecom.cn_&d=DwIBaQ&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=y6cIruIsp50rH6ImgUi28etki9RTCTHLhRic4IzAtLa62j9PqDMsKGmePy8wGIy8&s=tAZZzTjg74UGxGVzhlREaLYpxBpsDaNV4X_DNdOcUJ8&e=
>>>>>
>>>>> Is there perhaps some explicit reason that dirty ring cannot be used?
>>>>>
>>>>> Thanks!
>>>> When we started this series, AFAIK it was not possible to set the dirty ring
>>>> size once the vcpus are created. So, we couldn't dynamically set dirty ring
>>>> size.
>>> Agreed.  The ring size can only be set when startup and can't be changed.
>>>
>>>> Also, since we are going for micro-stunning and the allowed dirties in
>>>> such small intervals can be pretty low, it can cause issues if we can
>>>> only use a dirty quota which is a power of 2. For instance, if the dirty
>>>> quota is to be set to 9, we can only set it to 16 (if we round up) and if
>>>> dirty quota is to be set to 15 we can only set it to 8 (if we round
>>>> down). I hope you'd agree that this can make a huge difference.
>>> Yes. As discussed above, I didn't expect the ring size to be the quota
>>> per-se, so what I'm wondering is whether we can leverage a small and
>>> constant sized ring to emulate the behavior of a quota with any size, but
>>> with a minimum granule of the dirty ring size.
>> This would be an interesting thing to try. I've already planned efforts to
>> optimise it for dirty ring interface. Thank you for this suggestion.
>>
>> Side question: Is there any plan to make it possible to dynamically update
>> the dirty ring size?
> No plan that I'm aware of..
>
> After I checked: kvm_dirty_ring_get_rsvd_entries() limits our current ring
> size, which is hardware dependent on PML.  It seems at least 1024 will
> still be a work-for-all case, but not sure how it'll work in reality since
> then soft_limit of the dirty ring will be relatively small so it'll kick to
> userspace more often.  Maybe that's not a huge problem for a throttle
> scenario.  In that case the granule will be <=4MB if it'll work.
Ack. Thanks.
>
>>>> Also, this approach works for both dirty bitmap and dirty ring interface
>>>> which can help in extending this solution to other architectures.
>>> Is there any specific arch that you're interested outside x86?
>> x86 is the first priority but this patchset targets s390 and arm as well.
> I see.
>
>>> Logically we can also think about extending dirty ring to other archs, but
>>> there were indeed challenges where some pages can be dirtied without a vcpu
>>> context, and that's why it was only supported initially on x86.
>> This is an interesting problem and we are aware of it. We have a couple of
>> ideas but they are very raw as of now.
> I think a default (no-vcpu) ring will solve most of the issues, but that
> requires some thoughts, e.g. the major difference between ring and bitmap
> is that ring can be full while bitmap cannot.. We need to think careful on
> that when it comes.
>
> The other thing is IIRC s390 has been using dirty bits on the pgtables
> (either radix or hash based) to trap dirty, so that'll be challenging too
> when connected with a ring interface because it could make the whole thing
> much less helpful..
>
> So from that pov I think your solution sounds reasonable on that it
> decouples the feature with the interface, and it also looks simple.
Ack. Thanks.
>
>>> I think it should not be a problem for the quota solution, because it's
>>> backed up by the dirty bitmap so no dirty page will be overlooked for
>>> migration purpose, which is definitely a benefit.  But I'm still curious
>>> whether you looked into any specific archs already (x86 doesn't have such
>>> problem) so that maybe there's some quota you still want to apply elsewhere
>>> where there's no vcpu context.
>> Yes, this is kind of similar to one of the ideas we have thought. Though,
>> there are many things which need a lot of brainstorming, e.g. the ratio in
>> which we can split the overall quota to accomodate for dirties with no vcpu
>> context.
> I'm slightly worried it'll make things even more complicated.
>
> Only until we're thinking seriously on non-x86 platforms (since again x86
> doesn't have this issue afaict..): I think one thing we could do is to dig
> out all these cases and think about whether they do need any quota at all.
>
> IOW, whether the no-vcpu dirty context are prone to have VM live migration
> converge issue.  If the answer is no, IMHO a simpler approach is we can
> ignore those dirty pages for quota purpose.
Yes, we are running some experiments to identify such cases where enough 
dirty can happen without vcpu context to make migration not converge.
> I think that's a major benefit of your approach comparing to the full dirty
> ring approach, because you're always backed by the dirty bitmap so there's
> no way of data loss.  Dirty ring's one major challenge is how to make sure
> all dirty PFNs get recorded and meanwhile we don't interrupt kvm workflow
> in general.
>
> One thing I'd really appreciate is if this solution would be accepted from
> the kernel POV and if you plan to work on a qemu version of it, please
> consider reading the work from Hyman Huang from China Telecom on the dirty
> limit solution (which is currently based on dirty ring):
>
> https://urldefense.proofpoint.com/v2/url?u=https-3A__lore.kernel.org_qemu-2Ddevel_cover.1648748793.git.huangy81-40chinatelecom.cn_&d=DwIBaQ&c=s883GpUCOChKOHiocYtGcg&r=4hVFP4-J13xyn-OcN0apTCh8iKZRosf5OJTQePXBMB8&m=WHTbPjZer3ai__KbADSbXu_06rsu-MDRK4LCpRgwdXVXtMPlxN2MVMjGzsvBlOqz&s=sMVOOszKIvQ2vM03bdMEhVOAkeN55QgFUk_XbUm2JRI&e=
>
> Since they'll be very similar approaches to solving the same problem.
> Hopefully we could unify the work and not have two fully separate
> approaches even if they should really share something in common.
Definitely, this is already on my reading list. Thanks.
>
> Thanks,
>
Thank you for the comments.
