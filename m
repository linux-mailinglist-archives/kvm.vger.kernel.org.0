Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D40461ACE
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 16:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347988AbhK2P30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 10:29:26 -0500
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:59937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230438AbhK2P1Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 10:27:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+bK6F2f+MLN1UDPuMtGdkU7OiqCC0wntGujGPai9Ia1YBdgaWfqM1NTN14xmb/QBbJ2PdAr4fOiktSWvLIDRnFR2T7Tu1AVB3YosIP3U70rp0sFwZu1Tf9Cb4L6cw77+WVMWJYAujq6Az/pKgC5wz/BtqG4fN79O/AvaJuuc0Mo4XOL1eDCegEXVk4gsrIYjZMqjWc/ni3B6ocT7W4NUHogEFFPbnXMR/sm4UCmZ5MieHQTq7z3xsYPjilwZofWrQ/PZwizTf19TJAus+gvHoWgqs/dGBauj2RZlSyczyqiGKE9q7lks5655Oebzbl93OUV3OW/Y4RqQiZNirmHLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XnZeVtNLFAHRLgSbwssGAFL+C4C3mNV8iBQ8YrfgKew=;
 b=Qm9J5DyAr6wxTqSVjjN1Ber1j+q1biHBhZUZCaoUOTdwaGqEENx8GlfyWIxQqoz/gvHoAV1+so3N6u7IYrf/48onyXOAtxcbgJstan+4uyA00iKOidcRAVNf1Pvr3PySSW2vu0m+Sq2szQzxc1r//2b1ypNI0ax2cN6VGSOq5sZ3emiWSSwBEpGSF5Wry7zf0HP+CeKbuCaChTylwEcyOumiXgcX9edbq7aLgb/q0OvbhwCou1LW/9Fr3R48sBOmNpqLCnZVddYWpEx3gZGOnDVRc9LU5Ij08eBGDcd6cKWLR2eVpew3sE+Dc5N1SXw1ivNAvYZjPmGs0C+fA867MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XnZeVtNLFAHRLgSbwssGAFL+C4C3mNV8iBQ8YrfgKew=;
 b=m27rKhD4vkrmyztHcyK1ycX2hXKWy9fvLvZiZIgMJlOWFZRCm9JcLeEIEyV8KcXwfcEf5yp9mfu9bdCbyvmTVk0rA12T/JKSPu9avTR3M7TjAdHTp6sStEKK4MYiGd61m4x02MICOpd1scZiLD1fHS1XpcvvkiSSbkD51/4xl3M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Mon, 29 Nov
 2021 15:24:05 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1ddd:71e4:5803:e44a%3]) with mapi id 15.20.4734.020; Mon, 29 Nov 2021
 15:24:05 +0000
Subject: Re: [kvm-unit-tests PATCH v3 00/17] x86_64 UEFI and AMD SEV/SEV-ES
 support
To:     Marc Orr <marcorr@google.com>, Varad Gautam <varad.gautam@suse.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        drjones@redhat.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, jroedel@suse.de, bp@suse.de
References: <20211004204931.1537823-1-zxwang42@gmail.com>
 <4d3b7ca8-2484-e45c-9551-c4f67fc88da6@redhat.com>
 <81f95dad-b1e3-edfb-685f-8dafc92cd5db@suse.com>
 <CAA03e5FGj3FGeL-nfMBY_TA4UNFjaP73Hxkhkr1s2qGApHFCmQ@mail.gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <28fb4276-f24d-7d89-4038-b92403f95d5f@amd.com>
Date:   Mon, 29 Nov 2021 09:24:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <CAA03e5FGj3FGeL-nfMBY_TA4UNFjaP73Hxkhkr1s2qGApHFCmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0025.namprd02.prod.outlook.com
 (2603:10b6:207:3c::38) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by BL0PR02CA0025.namprd02.prod.outlook.com (2603:10b6:207:3c::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.25 via Frontend Transport; Mon, 29 Nov 2021 15:24:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f451a7cd-4298-4a1b-a72d-08d9b34c4765
X-MS-TrafficTypeDiagnostic: DM8PR12MB5480:
X-Microsoft-Antispam-PRVS: <DM8PR12MB548082202687D0542D8DD769EC669@DM8PR12MB5480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o9el3+H6q/v+LQH6vtFpgch97yD+su/taK6qBMTeMCDeGoxI9cVJXCwQfexBNMhzUDt/k5WDriUKNcSN8JJUH/queK3S+U5AuGnL4PAbpV/FwPaPNRTar4Qdf75YWoYbMPBliLEhANoA5l0MGrciSO18P+AG4LswefGe4vHiBQFT2EcWZXkPsnOgIE7I/nbNwttlzX228OHdYs67gsxVTmjDSw1xNYSvhWP93nOjSyQr4wPsSCcA39H6/cUUbMH3zLUERMxNcseUNkNMrthy7uryTUH+05w0GinCEfom36VVE7ilBnbTR94L1IVSxZLJ26Gh2MOqK9nvOPlwMU4IsfPnOjm9YlYnFHliT2Rg7Wm85DXliQz2RVbkeI2hl2oWWwPvvDodbTE8GO/lgp7VekUj4uBYsLsDWlGPym1WhO1J9u30X7MvvNhNlBxkoOu32vmHjRgN+2tYpF6PGpFIUjimajfYOgFU2/vU8xxZC3VFQ5LFpt+TS2muQsCzgb+O4yDHeR9fSpE4NNSrIykykzRbMEbCy0nZPFFFkaFAnTfTymcOH7fnwdfbd/cmi2wxdayHnoGEYOPB2wSqbHeHZYRBbs2oe/4uQoJrXQ5ekOqZdSMObZgPrdhZglcRY+74cWDRn8h3JfDqxTlJaywZP5ra1ntPD+isf0m+yq4flW7P4Hq0NWmeM7sXaFW6iC11AJPTVvQih8mMz7ygnRw2U7hlL9kU01GfeLYZsxNgAEhSn2nntoqFa/BTVTYGsNHWcbM9z7OoUsFlFIincupGTHBT2DSpxkRXgjDwJrsHnX4tC0QMNjRW3J3/iaJvkcl+2GsZzjuFdYdShgx6iRm4bFX4Dxndcy6WynZwAeHqheg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(966005)(83380400001)(31686004)(2906002)(8676002)(8936002)(7416002)(45080400002)(31696002)(86362001)(5660300002)(4326008)(508600001)(38100700002)(36756003)(6486002)(53546011)(186003)(16576012)(26005)(66556008)(316002)(110136005)(54906003)(66476007)(2616005)(66946007)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEU0WmRWYWJQTDFBN3dPRkdqMnVUeDJ0Z0ZvdzF0TGwrdHhidnlsaDNhRXZT?=
 =?utf-8?B?eVZOUlF3RVVySXY3Uk9pZFgvRkpyOVhuQTJrSElsaFFWMXdMdGU4NEdvWk54?=
 =?utf-8?B?VFU4VlkvTUJzQXhJYmFnU0p6ekdCYk96aWdJWXI0VXMvdEQ3K3VuYk0wUDFQ?=
 =?utf-8?B?cHY5ZmJHbnBUWFpNZkw1RTkxTkg5Tm5rejJRbEVEYVlxam1vTkpaVlBwVU9m?=
 =?utf-8?B?Zk1UN3lvZ3RnaCtyTzM4SVoyUHRZTGd5YjV2QXlyTkVLOW1HQjNOaUR2ZWVX?=
 =?utf-8?B?eUtRN0pvZHR3VHdmaUtsSFRwZk42U2VaYWZEMTlqWlJtNmt1VGNzU2wzdytM?=
 =?utf-8?B?TUJpRGdqekQ0cEc2WUhsWHlSa2VZanpvT3o2TXZibm5mREpNTXZzOGRHWU5X?=
 =?utf-8?B?YzVjK3hZeHZmTDlFd3B3MzkwSktsMEdSdlJLMWpndFVzRzE2QWQ2ZE5LWWxk?=
 =?utf-8?B?V2g5RnhrbFZzcjM5elQ5aldIWk1CbFp6VmpKN1FPZ0ZMeVpFNGczQ1B6QkxU?=
 =?utf-8?B?aThYcTB0ZTZUZWR2RjZ3cXBsbHh2eE5pek1LZXBlY09TNlBVaUZCQzJkSmU0?=
 =?utf-8?B?Y045MjJ2SXJzQy9XQzRET0dyN25aYWVwNTFkZ1owUVBMb0lOL09obnNTaVVv?=
 =?utf-8?B?dDBaY1drWXc5NWFpakh2OUFlTTdxaXRFL205L0kxSVF4SkRUdE5QVjBZalU0?=
 =?utf-8?B?U1hITVpHSHFEUWtHT1dqSW5oK0NDbjlFbWhrZFdibzVTWEtoRVNrU1lOR0or?=
 =?utf-8?B?OWtCZy9OUnhtRndOUE9rNE8ybTJHTWlxWXdCemtxeCtEZUNHb2hGdHZwMHBI?=
 =?utf-8?B?eURrMVFYWkkrK1ZLaEozQkkwbm5FeEM2VlhnNElsSDdvK1dPRDh1aFFja0Y3?=
 =?utf-8?B?azR6ZzRvdWFjUUcyc0tiN0xwVmV3QzlkRWk3Sk14ZWkvRzJwMkh4Y2IxVXlD?=
 =?utf-8?B?RHR5dG0xdWJlNFhvbUpRMjlQN25NSXFlR2drTkM1SXZLeXZrR0ZTMVdraU9M?=
 =?utf-8?B?VlFVaHBkOCtyRmx0T0xYbHFGY0tPNTdPb3A2MVlXbTVLWXBCK3V4U1RIVU5E?=
 =?utf-8?B?U2tGVDZGM2JrK2R4UmJ6MDR6ajN4UVhoNHZzS3dlSm81U2UySlhUZVAvUVFs?=
 =?utf-8?B?aUZxZis3UUxzc0hUYzRMS1FhbWo3OVk1KzdmWURkc0pURWp1cG5WbUYvaExz?=
 =?utf-8?B?OGxaZDFiT2ltSStrV21kajNhamExU0N5ZXVIZkF5WER4MjZ4RWZGbC9MZU1Z?=
 =?utf-8?B?VnNLcURSWHM5Y29RbjhKTVBwMjAxcmJUaHdMdFEzVWordzVSR1Jpay9rLzJO?=
 =?utf-8?B?NFRhQ1V4U2lJODlRampFczk2eGx0TkNpcDM1ajF3d0RmYURNa3lzbFhCWkE0?=
 =?utf-8?B?RC85RTlzak1UaE9lSGtsQWhWZnRHRmVqNEhzVUdJMHBndG1YVEJUUmFXL1Nx?=
 =?utf-8?B?dHdYaUlPVjNKbTZiR3JFRTRwQW5xdFIzUkVVWnBnUmR3SXZuSjdYVzM3Q0hB?=
 =?utf-8?B?MWJ1TDNaQzJiRzBJTUR4WUxuWDJtTnlJS0dXWGtrYUdMOWZYNkh2dlM4TVIv?=
 =?utf-8?B?QVFyeDNyY25UNUZyZldnZDVQem0vZS9Qa1d4UzZneUczaGY4b04rempJMUd1?=
 =?utf-8?B?RHNtdXhzWDQyYzlPUGsxbTVNNy9KOXk1d0pDQjdTdCtDenoxdnNZTTNEN0Fy?=
 =?utf-8?B?MnVuaVlqSTlsSTJvRjhpYk8wbHBxa2VPSzFKRFRlVWF4aGd2R3kxQlFMcmRv?=
 =?utf-8?B?L2N0VE53SjJTU1VHenRGZTdSK2kyT2ZPdkxoOTJlalVkNDZaOW0xUW5HT1Jv?=
 =?utf-8?B?eUFrWHJJRnVlQk42Y2lkb09EdXR5aWtoSHU0TUhEM09yWDdzMEpGczRkUjNI?=
 =?utf-8?B?Y01BVUtCOThaMU1aSXgzeGlOZFBrVnVBV2o4WjJGTkFDV2FiY2J0SWIrN0JV?=
 =?utf-8?B?ZjlmUjZhSWQ1RW50bnIydktSd1pIaDA2MlJMWXY0MTMwRnF3YWo5SXQxT0RG?=
 =?utf-8?B?NHo0S091QVI2elczLzl6ajVCaXFXQnhsUklDRHo1YWFyL2hOcmU4Y1BNUjFF?=
 =?utf-8?B?Zm9qcU1HeUszRXJoNEhWK3E4aitpSjJnSHRYbm9LaHlNbU5tZmVtYTVJMHVC?=
 =?utf-8?B?UkZmb0g0TWhzbG1ucTJlZkllVWJXTTB6UXVOMW1yWGVHUnN0eUZhcmtsWHBY?=
 =?utf-8?Q?RnCDPoi0WGlEBsMZMwlQMcU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f451a7cd-4298-4a1b-a72d-08d9b34c4765
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 15:24:05.2738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eZfLB4TMnbppQqzkijotAXeS+yDa2X+i6xNWQzGQJ28dcfEYEUOkWRKy0a4gRMoqZy/++Ku/XSIW+eEPwfml4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5480
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/29/21 8:44 AM, Marc Orr wrote:
> On Thu, Nov 25, 2021 at 7:21 AM Varad Gautam <varad.gautam@suse.com> wrote:
>>
>> On 10/21/21 4:10 PM, Paolo Bonzini wrote:
>>> On 04/10/21 22:49, Zixuan Wang wrote:
>>>> Hello,
>>>
>>> WHOA IT WORKS! XD
>>>
>>> There are still a few rough edges around the build system (and in general, the test harness is starting to really show its limits), but this is awesome work.  Thanks Drew, Varad and Zixuan (in alphabetic and temporal order) for the combined contribution!
>>>
>>> For now I've placed it at a 'uefi' branch on gitlab, while I'm waiting for some reviews of my GDT cleanup work.  Any future improvements can be done on top.
>>>
>>
>> While doing the #VC handler support for test binaries [1], I realised I can't seem
>> to run any of the tests from the uefi branch [2] that write to cr3 via setup_vm()
>> on SEV-ES. These tests (eg., tscdeadline_latency) crash with SEV-ES, and work with
>> uefi without SEV-ES (policy=0x0). I'm wondering if I am missing something, is
>> setup_vm->setup_mmu->write_cr3() known to work on SEV-ES elsewhere?

When writing a new CR3 value, do the new page tables have the GHCB(s) 
mapped shared?

Thanks,
Tom

>>
>> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fall%2F20211117134752.32662-1-varad.gautam%40suse.com%2F&amp;data=04%7C01%7CThomas.Lendacky%40amd.com%7C30e4810784c9456a7c4208d9b346bfe9%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637737938743453221%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=%2Fo0aGSzTWbVwLId4gEsnDpYfDsyMWNibjocX6whDK14%3D&amp;reserved=0
>> [2] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgitlab.com%2Fkvm-unit-tests%2Fkvm-unit-tests%2F-%2Ftree%2Fuefi&amp;data=04%7C01%7CThomas.Lendacky%40amd.com%7C30e4810784c9456a7c4208d9b346bfe9%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637737938743463179%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=k2kQzSZwmSWNVWWV%2BHJI0cfT71zva3Ify3UHFbSEOyA%3D&amp;reserved=0
> 
> I've only been running amd_sev under SEV-ES up to now. I just tried
> tscdeadline_latency on my setup, and can confirm that it does indeed
> fail under SEV-ES.
> 
