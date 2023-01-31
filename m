Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3868668388E
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 22:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjAaVVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 16:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbjAaVVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 16:21:32 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710C7552BB;
        Tue, 31 Jan 2023 13:21:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9ndO8ODOqQ1UoNMluEX8Zok/QtIhFGQo2/SJlQv+PS8TqK8jptJ+pvew5nFHNf35+hT4yfJGQUv/gWJU35EONHCNmY9KX4VqHyeAdltPwYoBVPz4/JW5XOXM3x6azraMZ98KkLdHFcXHa3HZjkEhrSBGIqm9+9+0uquitLx4YDDfkGQ0x+LYyOfm/3f7pHLrI8k7rjZh9A0BHsWvW7fInYPLJS4bk96cYVY+Iim5yI+rexH36eTbH8NtERhrSKfTwBD25TWRYDK7cs4iDXMEy0cumRAAZ1ln/w0gUmJrSeKOgRAmfwz9WmzpB7n5Qpwnmfe7H/Lzw4ZmTY+YXCeIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1jcaGJssLk/VdYAsDmQo9qypuZ7m9jEHcDUvWO2svEI=;
 b=AEJuyNEmG/uEc4NAFxNaNBQ1PRsl9lwhfE0J1n2dkE4lOMAKKJ8j9kJiXMKKPkFI5AKIFDVNGyASAwsjY4TlcoeyOjFVOO7Uiih8959ByB8MGtWaa1YlAJVzCNfEZ8lRkBpiBBkrMhikEOVfgMMFPyUFfwU/LwFeStj2ZcrS+RJX8vlZwoO+khLTqHL0i2sq8g4CRXaSGSEaVCKodAYJU3+al8fh5dOm/8BSp3p2EDA03PSpIYreXUEB+oM5GHQKxpfJuzztBbPd5pHiVQDkc7xWpiSzfcHKUmA0zO3AIKmhuR5GIGQZkqb2223CZVd+ENcMMhq4VWhp+zbJCAzJzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jcaGJssLk/VdYAsDmQo9qypuZ7m9jEHcDUvWO2svEI=;
 b=d3d1edp9ZRvx3Vsj2Qv+naAiPxPAtWuwmvPNtly8osdFOrQG7g5zhXoqDQTXWlOiS+pJqzgZmVZIRQ5SUrgRxz9YjC5wfYnQeU+xSjT8/4tYQOyyc8hoOXkCRFU7CcxaiaoIyGyGASHzeSiw2KRACt+fl23opiyeDWfp/Q6DDEU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SN7PR12MB8171.namprd12.prod.outlook.com (2603:10b6:806:322::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 21:21:29 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::6cc0:9c7a:bd00:441c%9]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 21:21:29 +0000
Message-ID: <682c0bf9-ccf7-9660-21fe-925ef63c5fbb@amd.com>
Date:   Tue, 31 Jan 2023 15:21:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>,
        "Kalra, Ashish" <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-53-michael.roth@amd.com>
 <aab7ed11-870e-579d-9328-4c32d9936392@amd.com>
 <66039193-14ca-5edb-d8d4-ca732d8c13a6@amd.com>
 <119075dd-5f3e-a393-f543-6cdfd34cd337@amd.com>
 <385016f9-e948-4f7f-8db3-24a0c0543b3d@amd.com>
 <55e5f02f-4c1f-e6b0-59ba-07abc4d3408f@amd.com>
 <81037a58-6b5c-cde4-79fe-3686d9b8a551@amd.com>
 <b0baa6ee-ea6d-3a30-d5fb-3ec395896750@amd.com>
 <dbcb6666-270a-4867-6de7-73812d32fd8c@amd.com>
 <7fb25176-3752-1be3-66d4-a7f5a0e1617a@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <7fb25176-3752-1be3-66d4-a7f5a0e1617a@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0152.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::7) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|SN7PR12MB8171:EE_
X-MS-Office365-Filtering-Correlation-Id: e8411d55-62bc-432a-2c89-08db03d11dcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nbIgjyy/RhY/gdmrdndoZTivkQYW6PuNO8HLED5x62dDTvizYXEx6CIAEDD//dCMoqQmrpYtAtICRWE/r9OJVmxCx2+62LX40duk9l/hy88hGMKbxM6FJ2npUBSsLkOLGW9bhhl3JdbybwZzcqx0V2xE+3qA8Pdr/QUqtpSaIPhms1OF5ynpFfpkYQX1ayk5wAYIdW0RVNfF2lVA+JC28xpHjxRmv0gBL2Ao7folXACvgjERR92dpYbADEhFMJGYVjfrgWz+jDo5/pop49vV6Z9AM/vlihmGz8zVOV6FEeuPqNz3cG6yRxC1LgSun6xRFtLUtpyH5P1f2cWjwAaaIqaJ5VjTXpeNuYJZyEBeUCJuJtc9bEwPd4uEqW8ncwFiGkDMK0xoLxq7krqEZwsJWOl1QV3x4U+9lEaGmzQKQCehko/4fKLAY3t1uIwzbKtDyKlafmpF7sgT7YnjFUQUXfQjrSRX5u+Tc7QGwiA5km/PIxuIaIp+XI78nXkX5GtaUcjzllwaW5BiSabuPymkoFPfc+kzmWNL9KubWNQyAGLrwyDLYhfpKtTbWZ7WnCHhHuaTIOHhwWwWt5Sgrphe7knXbi5a73puc0isO+dzqswUdv8LlduMgdvYMBczV4vKOvsy1reSWTzeKuAs79ghqRdvtU6oIRp+A0wYqZAgteaLqzxRukiB243sQXahPRmJSEVl0RcdE2GvLsLXc4Jw8l1Q8LFvQqNXoe8FM9oHH2w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(366004)(346002)(136003)(376002)(451199018)(86362001)(31696002)(38100700002)(478600001)(2906002)(110136005)(7406005)(41300700001)(7416002)(6486002)(6666004)(26005)(8936002)(2616005)(5660300002)(4326008)(66946007)(83380400001)(66476007)(66556008)(6512007)(53546011)(8676002)(186003)(316002)(6506007)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZlZPTjJla3BEWVRlT25JM3RzaGE4VEV5MG53aHBtMnlKOVpPWERrWlNaNENy?=
 =?utf-8?B?NzZvR0p4M2o3UmhPTGdZM1QyMUdha2lrc2M4MHRMWFp2bzRVSUc0VHVvY3o4?=
 =?utf-8?B?MnJYb01QeFdjRTM1aVpMdm1KUTNCc2N2c1RPSDFQYW5EejFvVlJNOGJOaHF2?=
 =?utf-8?B?aTdZRVRhMDV3b2R1NGsyYi9tR0xPTldIQkV1ZVhLL0Nndm91alB1NU8rdkIr?=
 =?utf-8?B?UStUenhneVk2dzR1WmFOb0Jwc3U3MUo2M3ZUdks3ZmxIRjc0SmlGamZlbWMv?=
 =?utf-8?B?V3dkbnZ3N1JZb0VXR25qWWV3Q01rNldLdGNaZzQ0NGYwcWxtbmt3VHl6MG1l?=
 =?utf-8?B?MlB2NFdjYTlCVWs4Q1RMT0h2VlZDSEtWcU9vcnZxaGxENlUvOGs3ZGYwenZh?=
 =?utf-8?B?WVBPOE9BT0xJdWtZaHlmc0duTkR0UGZZNHNEMUZTblQwQzB6N2k0S05LUGkx?=
 =?utf-8?B?NTA1TTRQK0Jla0s3cnlqeXE4dWdsSUFibE1YK2lhdVVmQmVQcFZNRzZDNWly?=
 =?utf-8?B?NktrUTUvWXo1dTVmcEVkMmtOMTI2d1FISERFWStKQXEvalI5Q3ZENHB3SGxq?=
 =?utf-8?B?M1hLdzBVSkxhcEFGc3BQR09ydWgzQ09LOVVVSE54ZGpHcjZTbWFuclQ1UFVD?=
 =?utf-8?B?SUlzU3pvSXBHVS9LNHhEVUYraWsyeHArRERySUJ0cy9wcUkxcHh1YTg4NzlJ?=
 =?utf-8?B?Qjl5d29QWEk0WVlQK005K3hxVVA5ZU1zNWJJU0JDc2xCL3docEEzWkY4Y3VN?=
 =?utf-8?B?cWNRbTNkQTNETUw1RzBkNTB3OGlNNmpXQmNCejcyc09pbzRkSldvanYvekFr?=
 =?utf-8?B?ZmllUXpWdmNJMU5lMlRSdW1pdEdsRC8zZTJlSjBJb0Z0LzY0bTUrSFUxQlNH?=
 =?utf-8?B?OVJCM2QxbDZFam00enFsVHdhbUJ0RUQ4NVMva3R3K2wyd3pLQnM0cXJjYmk1?=
 =?utf-8?B?cFEzb1ZRM0dMYXBEc0lPVVZub29pem4wUFpmTWxWMDBTeExDcDBpWVVITE91?=
 =?utf-8?B?TUtiK3I2UElqYlVUZFArQVFvWHZEWmlqNW5sWDRvdFA1eU40TmxXU1dtU0NP?=
 =?utf-8?B?UTh2YzVZemlYREloNW1aWFFhcDN1MDRRZVlGNHd2WkNwdS82bE9JVGw3SXQr?=
 =?utf-8?B?WFEyWW9JRmJaNWlzV0tYREZNbE5MdS95MVhZSHU3MzVDN0tUQ0R1NURvdXhq?=
 =?utf-8?B?WXZ1RzdrL1BUWEJCZllwOHNUYWxGY04xQ1YwVEJ1M3laZXA1K3ZLbnl4Z2ZQ?=
 =?utf-8?B?S2IwaWF3RW5oaXZZMHI1WW9kWEZ3M0E0YkdtTHRxLzVueDZ1dCtnaGhhMksz?=
 =?utf-8?B?ZTRZbll6bVdlZ0hsVm9xQ2xTZXNObnBFdkVaWHNHS2FvSmtZWlB5b09pYXQ1?=
 =?utf-8?B?djlyMkxzcUFqU3h1d00rN0lvb09pTU9yUHV3T0ZoL1FQeG5Fc3BXa2s1Q2xZ?=
 =?utf-8?B?RkRZb0NzNm9oRFJIM3hNcm1qWHVnZ01ITzl5SDBxcDlXa0lmKzIwQ0c1amNy?=
 =?utf-8?B?clpMRit3bndZTXVrbWpMSW5JU29zQ25RNlIySWtqUm1CNGxCU3VCYkRxWjkx?=
 =?utf-8?B?WUNuVERhelVjZ0pIYzJiZmFFdXJCNTdzeFdwU3lWRmppRFRweFFRQitNTGZQ?=
 =?utf-8?B?ZTJyVVVvYnFhK3RBaVUyS0VBV3dBbm1yT1Vaa1VzSnZHRDZXSnBMdDJYMFFs?=
 =?utf-8?B?K3hWY1NaTzMzUTNZQk41ZmlmNUNsNWJvWC9RK3p6TWxvaDdmdGp4NXFjTXBL?=
 =?utf-8?B?WnFwWGFiWHo4djZEcEIzcHM1TmQwZzR0TTIvaFVodE9aQldTMFkwVlllQW5P?=
 =?utf-8?B?RjhXeE1PM2xCMHY5WldBZU9CTnY5M0h4VExpcDVoTk4yOTFPcE0yNFp6UjNp?=
 =?utf-8?B?MUhTbTl4SjdKRGJjTWZoWXlvY2txdnRFWmdjWjYzdFZxdDI4WDVVVGtxM3kr?=
 =?utf-8?B?RTlRQ1ZlNml3bFZFN2RqbGdnSnptYVlZSnQzTXpkQ2dZc1JJN3M0S0dVdTZQ?=
 =?utf-8?B?UWlrZndwQVp1ditiR3EyMXpGWDNPM29BSW9KWXJ3T0hHZUdJMGhzcWVLcUt3?=
 =?utf-8?B?Qno4Y1JndzVDNFhLV0JvOFRXc0NnWCtCTGQ1K3dtdkJGNDhKdm9oUXpGVGZi?=
 =?utf-8?Q?Gza8rG5ss08L9jy6QWz2bdfui?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8411d55-62bc-432a-2c89-08db03d11dcf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 21:21:28.9033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IhLaeXGotpDqq1qYEWbHhp1F/g2aBM7YVFqrGvYp38SLi8E03Xf8keTuqDRlWp2oI2sR4oY8SQPnp6NC/4aWTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8171
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/31/23 14:21, Alexey Kardashevskiy wrote:
> On 01/02/2023 03:23, Tom Lendacky wrote:
>> On 1/30/23 19:54, Alexey Kardashevskiy wrote:
>>> On 11/1/23 13:01, Kalra, Ashish wrote:
>>>> On 1/10/2023 6:48 PM, Alexey Kardashevskiy wrote:
>>>>> On 10/1/23 19:33, Kalra, Ashish wrote:
>>>>>> On 1/9/2023 8:28 PM, Alexey Kardashevskiy wrote:
>>>>>>> On 10/1/23 10:41, Kalra, Ashish wrote:
>>>>>>>> On 1/8/2023 9:33 PM, Alexey Kardashevskiy wrote:
>>>>>>>>> On 15/12/22 06:40, Michael Roth wrote:
>>>>>>>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>>>>
>>>>>>>>>> Version 2 of GHCB specification added the support for two SNP Guest
>>>>>>>>>> Request Message NAE events. The events allows for an SEV-SNP 
>>>>>>>>>> guest to
>>>>>>>>>> make request to the SEV-SNP firmware through hypervisor using the
>>>>>>>>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>>>>>>>>>>
>>>>>>>>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>>>>>>>>>> difference of an additional certificate blob that can be passed 
>>>>>>>>>> through
>>>>>>>>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>>>>>>>>>> provides snp_guest_ext_guest_request() that is used by the KVM 
>>>>>>>>>> to get
>>>>>>>>>> both the report and certificate data at once.
>>>>>>>>>>
>>>>>>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>>>>>>>> ---

>>>
>>> And GET ioctls() return what SET passed on (not something the firware 
>>> returned, for example), what is ever going to call SET? The userspace can 
>>
>> As stated above, the firmware already has the information needed to sign 
>> the attestation report. The SET IOCTL is used to supply the certficates 
>> to the guest for validation of the attestation report.
> 
> 
> Does the firmware have to have all certificates beforehand? How does the 
> firmware choose which certificate to use for a specific VM, or just signs 
> all reports with all certificates it knows?

 From the SNP API spec, the firmware uses the VCEK, which is derived from 
chip-unique secrets, to sign the attestation report.

The guest can then use the returned VCEK certificate, the ASK certificate 
and ARK certificate from the extended guest request to validate the 
attestation report.

> 
> 
>> This reduces the traffic and complexity of the guest requesting the 
>> certficates from the KDS.
> 
> Guest <-> HV interaction is clear, I am only wondering about HV <-> FW.

I'm not sure what you mean here. The HV doesn't put the signing key in the 
firmware, it is derived.

Thanks,
Tom
