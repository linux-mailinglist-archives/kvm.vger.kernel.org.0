Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF20561E18
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 16:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237253AbiF3OhN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 10:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235980AbiF3Ogz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 10:36:55 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E4015732
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 07:31:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IguPBMgjJd360sM6Pul+mQ3pC1omFXBFoCQEuNwhMbJ2CrvJ/dgYER9K6nS2+diRpLj7On6EHp8RQaR40lAmXnYZ2AjRDSqwdWe1ccMD4lOjX/NBBbN15I0XgBfo32tnslkI0imPzpKLTLRNOFWVFAyav0qRPTg5rUIXetwFOsqeQ3nH29ETSA3d0jSCvF8ryvaj8+zQyZkGnd1dAvWLA4+PaY/KS0gJmGR4ogof1t/eJFQb1nclODUrvR4M2iDEhWqNWDDtz/xpvEfK4aHkT+seYElhaEAfSY0rC2yMKmVOTPU/+F/1eJfmGB2W1lYM5KOvaK5E04fXfpxT5lA1tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3pDULOZalfRaWqqg+3nQMrghgVGf+zwYiben9y/RIBU=;
 b=lz9TWuACCUM3KZoQGXOjJQPCeufQ1DinDTjm9fcqtm6NtWuA3mlOYKiHCMuwJBSOPA0DaPkyT8VhdikgWb1ZRyoEhME3Ye5fqcVqaG6DZg3dZCT+iTkIMBsxWUTvnCs7TbyevfPhkt4GVfR4KyQsLW08plZgHHxis5mGFQcoWnOFWpnIU6Uun5c5fNFgPRmNuBPZYxWK848iG5xyOfLEXde1fBKBqQqE3eVLcw1+nRsDx7XlBzqTczp46qllYLWDxomHXCSrHkYAAslK0RTr3/kMcEErCJU4NR98hiqnTKhp3Sl7zw2kAfEwLWDK5poT+z4EHSsfol0gmpXtlKvgaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3pDULOZalfRaWqqg+3nQMrghgVGf+zwYiben9y/RIBU=;
 b=hlA1Rx4Omn0RTGrjXwrnuPLZzBnIjr+MnNE8cVNEtrM8bd8C8ndg/wkWJHbQNLWVHjG2/BOpaGi36VE0aoPQmsAUCzXGbOvvpj3Y/jTFdUkQIuaPx1aQDRbinEhqPlcvLXKvsox4qsh3+4ym/OxO3gFgFWG19GMfIozrQdK+SCE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB4841.namprd12.prod.outlook.com (2603:10b6:5:1ff::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.15; Thu, 30 Jun
 2022 14:31:54 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1dac:1301:78a3:c0d0%4]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 14:31:54 +0000
Message-ID: <be2ebbbf-1568-1eb5-b2ff-73819d4e872d@amd.com>
Date:   Thu, 30 Jun 2022 09:31:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2] target/i386: Add unaccepted memory configuration
Content-Language: en-US
To:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Dionna Glaze <dionnaglaze@google.com>
Cc:     qemu-devel@nongnu.org, Xu@google.com, Min M <min.m.xu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Gerd Hoffman <kraxel@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "open list:X86 KVM CPUs" <kvm@vger.kernel.org>
References: <20220629193701.734154-1-dionnaglaze@google.com>
 <Yr1bYiA1w/lMX76k@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <Yr1bYiA1w/lMX76k@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0070.namprd13.prod.outlook.com
 (2603:10b6:806:23::15) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfca9ad7-940e-4642-2163-08da5aa54770
X-MS-TrafficTypeDiagnostic: DM6PR12MB4841:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Ss0RlaoJYkqiR+VIa98WD7tSQTKNcOecI1olT+qRj7ZvDfsUvJDLun3dEXDc9LHcTEiTyC9fo/mtAbR/1Fjlsoulzom2W6R5iRm2+oJDRXC+TMCbrXup2Hfi6XHh64wz1aIYZsq76pvUCG7UQfoMDXSlOxY1mQbOEbAqDuzTq4741kLly0MHhQDXJOQ9W6++qbQ8QcS6Jb0JPjkxsOws1+Y1MbBu7SwLLqSn0+a5LAvlAQxaMsaiTk9rOBlwgZkwct48iwFyZG1g4Mv+MZXS3cYLxstyzwSg0wduxYlAS1+hgm3ZnzKQh2ncoxCl39HjuG+pszgePA+cCevtYC0LM1Oeth/2B/xg3ixbUGwg9Vh9RaFaKr3FMT+PQWUjCUERTuFdDGF70e+YJS+yX8B3zSQ91902IOtJpSDKArUKuNQB9uJ1DUBhaTUB3YdLYfZN9cyLhcO7geURz3FsApD+IarGGGIZ+if1SXLAu1aLzuQl4gnZz2QFiLWu3SHWWxJ5Dks5CmFv9yBAufvzjmhStTNundJPd6g10G0L9zwtHIixcBexnZlVlj73YyNGRhuVF/eWwXS1D5v8H0VCLcyM4HSbrpsUFZx+zSUBWs2dp0fIA8tatu3hsrLWt810noPQYx3LBoce8Vgw8q3vYw44fkQRZ8hXHU2KSEATqJcQIFPXvdwz6FwVQwZBD8W2rPyY2/ouxQYRMF2ffqNDIYiUm8U7OfJpZRowVtCYeatFqUzN2FQ8az2OzZdRWMNr82Jnr5FsxQz89BL6bB7XLYDPR+l7zkZNcM6p6H70INMXI4e3bApTECvPjVq4CsFXxh7qyBSdCmqbVQ9o18DVhM2rO2JJRmHm7k383COzuJ6sAlVVGfFDMH/pVwEExR5h+Hq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(110136005)(2616005)(54906003)(186003)(316002)(6512007)(26005)(53546011)(86362001)(31696002)(6506007)(38100700002)(31686004)(41300700001)(8936002)(966005)(2906002)(6486002)(6666004)(66476007)(8676002)(66946007)(66556008)(478600001)(4326008)(36756003)(7416002)(5660300002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0FoNEQrdzlsaG5yYlRUV0ZoYk90d0IyclFsYTZValhua0tTMSttNUkwZXcx?=
 =?utf-8?B?eG1qZzhYbmdCUU9CMVI3QmlCOGpSVCt6L004YnVLQkZINXBlMDdUWkpMbmZC?=
 =?utf-8?B?VWFnWXQ1THg0L2k3UHBHdUV2VDcvVERhNUZhRDd1b3h2eFVvZlpDcXAyaXMv?=
 =?utf-8?B?bVMrYzJoOW5SeXNtRmNxYlMxOEIyRVVPUmZIc2FlNGpmY1J0UzZaK2lHZTdT?=
 =?utf-8?B?eGlyckRFM0hJV3pEbEpjQlRjUTF6QkVwK0lSaFpQaFo5ME5wdGM1YXMycDVl?=
 =?utf-8?B?RTNLVHdCNXE2UFg5MndPNDlaZFY4TmJrenp2Q0tmWjBHc1owWEFpL01nQWRu?=
 =?utf-8?B?cnB4eFd0VlMzeUIvRlBseHhLWC9oQVlJZ3E3QnJReXhnV1ZJQmJJUVE1WG13?=
 =?utf-8?B?bE5yQ3Fvc2RvOUNnb3lLQWt4ZkZXLzlWdGZxOWZwK09pTDBtVEtoZi9BWjhE?=
 =?utf-8?B?aGxvRjlIR0ltOXF5dHJoRUR6UmZudSszZ3BKaEJKV1pJdTdETDlsakdHMXh0?=
 =?utf-8?B?SG4vY2NVcUY4VEhkd0JrSkNJcGVxVHNEZG9HWGxJNEZmdzI5a2FxamExL1Yy?=
 =?utf-8?B?eGx1bEMxWHd2Yk9mbkkwd0hwWlRZUDZ3VFl1TnZEd01kTUtqNEtGcUZTNDJC?=
 =?utf-8?B?OXZiK1FUMHRtUXE4RmxjR09IVjQzUXZRMkhhSThBa1ZXUVBEOFFnSGNrSXZN?=
 =?utf-8?B?ZHV5SUhpM1I1WnNsU0FaejlqZGlYakZXRm5mbS8xSUpIY0tWU3p6djUyZTgr?=
 =?utf-8?B?WkpiM1E3TmZmT0ZvZGUxR3BDK0hCb0ZRK3hvd3FJYU4zT3hBdVZHYkRuVjEw?=
 =?utf-8?B?eThKY0VQUStUMmZwbExxZWlTbVpFMWlhUElxa1d2QkxiQVY0bzRBVnFNUW1y?=
 =?utf-8?B?Y3RIMG1aR01jakdqK2dZRHV2bGlPWnpQVkR0aWFPQlpVNmx2SHpIZ2JCeFBH?=
 =?utf-8?B?bkJ3Yjd2WUttRUdpOTJvTGgwcy90SkcxVVhJaUpHRG1BdXJZL003RTE4djlC?=
 =?utf-8?B?VGJER0UvNHUxUDdnVnk2clhZZ0FXRlhyWkdYMHlSSDZGd3VMdzRoa0hRczJQ?=
 =?utf-8?B?dWw0cVY2cnowSmp1R1ZWbWFpOUlBK1NuRHFrMmVKSGJNYnQ4UWJodFdXdFVp?=
 =?utf-8?B?MDM5U2UwUC9NdzBwOFdWd0h4ckhyTVIrRThhOUNLTWN4M0c0WC8wbnhqRi9z?=
 =?utf-8?B?WU5nRUdBQVU2czRVYVQ2ZWczaUJaMDVYVm5IaVJtVG5PZEdBOXhwNGVZNHNv?=
 =?utf-8?B?aGNCbnhFSjNEYzFWcDNTRFBCKzlzTzV0Mkk4WFRtS29zVjBnWWgwd2JlNVl5?=
 =?utf-8?B?MTExZnB1OXJvWHJHejhDOVdVTldWRDRLNStmS3JBdk54QXRIOHo4NnVTcG9K?=
 =?utf-8?B?eGZPaWFvQ3ZLaGRtYXBDOVpwVEU0ak96cGE2UlI3U3RXSzdzOTBLRGs2bWk1?=
 =?utf-8?B?REo0bHA1SUtZMjFyYmxMYlc0dDY2WWQvQkpSeFUyTS9kYm9Uc1U2YnVmVk54?=
 =?utf-8?B?RGdiNDRWUnFFOFMwNTh6d0RpVnZDOXU4a1JFcFdRY0RzdHNlL1pBS2ZDdmpU?=
 =?utf-8?B?eE82SHJRa09SQzJLdUhJaGp2L0NvVkgvbk9UYy9vTDNqQlF5Qml0RG9ZU1o0?=
 =?utf-8?B?RkxtVmM3RGNGQXZnalRUSVV2NzRUc2xjTnBjdUUrM1lVZVdSWG9aZFU5QWNY?=
 =?utf-8?B?RW01SHBVSEhRSDFFRWw4NTNZRXQ2V1BLQU9xNllTNmh5UklLWXZSMlFhdG5T?=
 =?utf-8?B?ZTZ5QS9xSEFHOUdlSUNXQytlUWdlMjNBZHRlc1I2RmoxT2NwVmU0UWpQRVhu?=
 =?utf-8?B?cFdMaHR3blRmYVlvMW1ITWJOamFJSGZpSUhMaGVMR1I5N1RjSVpNbEZBSDVE?=
 =?utf-8?B?ZFBTb0dSTndJNi9hclRoVnJXQlFCdmMxSUZzQUZHZ09zR2hWREQ0M3pIcExv?=
 =?utf-8?B?dG1BYWlDbXFTUnYyMlhqTEtvUnd4Q1U2aktKSExYVExjZkFLZlNYbFpic0lS?=
 =?utf-8?B?REpsSmhLNHdJcU1Uc3Q5andYcjZrOTZVekJzUm9yYU1nZ29teUtEK1FZUlZT?=
 =?utf-8?B?NkF4dytvMDNJd0dvN3FkdTU5aG1KcjhJZlNqQUFYTDhxb2h6amFZMlhSMmov?=
 =?utf-8?Q?sbQsSkVb1PZNhuZGdKSrbLYp2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfca9ad7-940e-4642-2163-08da5aa54770
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 14:31:54.3492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hcUf+QKxJPhCJXbL9/RUFewxuB/m0BR6Vn9BHzXAFHucV1f6xDFxw2k0DjzbnHna9WHGrsi1N3inHf559dXK0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4841
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/30/22 03:14, Daniel P. Berrangé wrote:
> On Wed, Jun 29, 2022 at 07:37:01PM +0000, Dionna Glaze wrote:
>> For SEV-SNP, an OS is "SEV-SNP capable" without supporting this UEFI
>> v2.9 memory type. In order for OVMF to be able to avoid pre-validating
>> potentially hundreds of gibibytes of data before booting, it needs to
>> know if the guest OS can support its use of the new type of memory in
>> the memory map.
> 
> This talks about something supported for SEV-SNP, but....
> 
>>   static void
>>   sev_guest_class_init(ObjectClass *oc, void *data)
>>   {
>> @@ -376,6 +401,14 @@ sev_guest_class_init(ObjectClass *oc, void *data)
>>                                      sev_guest_set_kernel_hashes);
>>       object_class_property_set_description(oc, "kernel-hashes",
>>               "add kernel hashes to guest firmware for measured Linux boot");
>> +    object_class_property_add_enum(oc, "accept-all-memory",
>> +                                   "MemoryAcceptance",
>> +                                   &memory_acceptance_lookup,
>> +        sev_guest_get_accept_all_memory, sev_guest_set_accept_all_memory);
>> +    object_class_property_set_description(
>> +        oc, "accept-all-memory",
>> +        "false: Accept all memory, true: Accept up to 4G and leave the rest unaccepted (UEFI"
>> +        " v2.9 memory type), default: default firmware behavior.");
>>   }
> 
> ..this is adding a property to the 'sev-guest' object, which only
> targets SEV/SEV-ES currently AFAIK.
> 
> The most recent patches I recall for SEV-SNP introduced a new
> 'sev-snp-guest' object instead of overloading the existing
> 'sev-guest' object:
> 
>    https://lists.gnu.org/archive/html/qemu-devel/2021-08/msg04757.html
> 

Correct, the SNP support for Qemu is only RFC at this point until the KVM 
support for SNP is (near) finalized.

Thanks,
Tom

> 
> 
> With regards,
> Daniel
