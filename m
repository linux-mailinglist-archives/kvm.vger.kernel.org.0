Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4430A412EAE
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 08:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhIUGj0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 02:39:26 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:50044 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229686AbhIUGjY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Sep 2021 02:39:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1632206274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SUBnoBwLgX2G3TCutkgZLFs05FJD5b9yKOUjRuX9c9c=;
        b=hXek0nmCeu6O5QqJQjSHVJXU78PwBD4ycGsHvkfrewAtKn4CfpFySC45q9oMLe8xVggOnL
        16Q99BHypfrxWgq919lVL7EUad7t7wi5YfRYbTapirfRpoXPeY2gA5SlY5fXLTV4XR4lQz
        clynxwARdwcgoHahQ8QF4+YFzJkW1r0=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-23FiM7gAM22M-0mgtTpotQ-1; Tue, 21 Sep 2021 08:37:53 +0200
X-MC-Unique: 23FiM7gAM22M-0mgtTpotQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ryp2pAAjaZ9Vzh/0M+HvZrbQBkyE2HIn0QNFcEpPq4c7nhcEfL/ZVJmXE/pD57KyMRaDyxmvI8wEjPbwsxoJzuyqB947e7IwoUPjJ7N2X0hSdBi0QqL9QT2O1IcD65IepCgmCd2v22sbtL5Haayk+XgTtCALzMf9ZYiBqbIk08eWBzMayfwpsDch43HpD6474gSndmv/a3QIRA0Yt+EMFJRBTuDYM936OX5ADciHMqX5HiCFWxX2yfijxEwHIgzq9pBP7aVqjCc1m4okKoJQwq7k+FAACtyvUfMscr0b0/rSAyFCTO+TcCiR1oMv6ajfnmaK3hdWKt6cXI9A/OGx1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=SUBnoBwLgX2G3TCutkgZLFs05FJD5b9yKOUjRuX9c9c=;
 b=b7UZr3UGevg4yEgYjFaxH7gEMG8zReK75eZnzdYrLJ0jZHPDjNDiU5YuJRf652DG8y64IOXcD9Si6OkF8cbmI3N7Muoma71oQsKnb3JQ3pwH4kJGhMkvEaMr3GB3Xm8HTCfzz1L1wHUj7+6YltVFxaxk4o1nSw0TMI7wHXBNkwmSP/5N2uACy5ojQK+jWQZEBWdl8rNrQAQ3hK7VruPkcjpJZ5bz8kppIhbtXL0o3IQ5ZK1eD3VceLRSzuMEVOwxOw34Vw26WGD8DreHZbXIxMgSXobI4BSUFBaO6QmwHrov2mUjHgPYBviqn0ueM0bXQpdHXVlp5vLXbiqQqY47Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR04MB7059.eurprd04.prod.outlook.com (2603:10a6:208:192::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Tue, 21 Sep
 2021 06:37:51 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::8517:cf1e:aa0a:f0ae]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::8517:cf1e:aa0a:f0ae%5]) with mapi id 15.20.4523.018; Tue, 21 Sep 2021
 06:37:51 +0000
Subject: Re: [kvm-unit-tests PATCH v2 01/17] x86 UEFI: Copy code from Linux
To:     Zixuan Wang <zxwang42@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zixuan Wang <zixuanwang@google.com>, kvm@vger.kernel.org,
        drjones@redhat.com, Marc Orr <marcorr@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com, jroedel@suse.de,
        bp@suse.de
References: <20210827031222.2778522-1-zixuanwang@google.com>
 <20210827031222.2778522-2-zixuanwang@google.com>
 <0f423c39-a04d-160e-b3b8-488029080050@redhat.com>
 <CAEDJ5ZQJ=D3ZwzMwp_jof-xLON=mZ=JFJMmvrwqcL_zW9CcJ1A@mail.gmail.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <56ccfe75-f58d-4eca-8a26-1f1da28d1169@suse.com>
Date:   Tue, 21 Sep 2021 08:37:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAEDJ5ZQJ=D3ZwzMwp_jof-xLON=mZ=JFJMmvrwqcL_zW9CcJ1A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12)
 To AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.77.162] (95.90.91.212) by FRYP281CA0002.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 21 Sep 2021 06:37:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12fe66e6-af1d-4e1d-8204-08d97cca555f
X-MS-TrafficTypeDiagnostic: AM0PR04MB7059:
X-Microsoft-Antispam-PRVS: <AM0PR04MB7059A7196BAD7707400DB42CE0A19@AM0PR04MB7059.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bdJaAbQSjZzwAKUonDG602tT4zLGLPKM4y/s21AYkuSrl7+bCUzux42smnqCHOrBerEB8X6RK08/EX3DywoELti9rfTiNOfHFccYcWJIn+wpZc4mPvCKk7I+1Xqap0JnrET5f6JB53pJrO9tGBCUx3ai6wJfddzXGbsa+o6LWK4UJSeowNjHyvZA7VBXtxgNlY/3nz7/vVQKnGkb4ZQMQDq66/a9YkXsTjPRhJ4guxwIYw9/MHUoolIgnl2IfQX1UuaN1QGDJdVkjpfQQgGz7yVr3nG4qvSdeV/1KcBCwhpJUEt4+B9fWhhN1oUCrpocV278gSCI8nUe9iDucWAnYzdyIrg1NeiLy4DILyZRGxiOilWC2V13FlP4aihAenifLPXpniagQzHnHe6wzPtT0cIBChSc3955hJ0uHuJzyPGGsy96v3A/q1HfQaB6Bj4zfAwF4v43od/JsD/ThuEZxCOy4B5CapkDq02Oj4tihSLC+2bjue50v0AcpLcQnOMwLanL4o0+zG42kp+AzMsezuRFyx1ZoFXzCclDPgGcKYBg5wGdEm1vnox9Ew/9nFlxzyVq/FxWOYkEBElXkhJKzd0YAV2iNfgK5++MTp76VH8crGvcMIsz5uq4mdqoa+KyuV7dLwV37F+iAbZEb18ziLxWduUALsuDvmfB7ewL3DosgkHFbJpeGRO0NZ6M+W2EyQeZE9NpoJCOww0ZZauXQmVIXmzuHlv4XlAz+87iPneFIQaiGDsY7nmAYgCO6p3qhPZFFWqBsprJGMjqMRCETHR9B6UQfd4L1Y46cTZPZE/AE3qXFaimuimCDjCbc8ga0vPQ4d0HlL+IQSxoVTk6J5odDl86S6o5Wp8D6iJ/R5MbdXXS0TQ1lHz0xcyiW9jWaSUhmdJDAHITRHMnbOFhVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(396003)(366004)(346002)(83380400001)(53546011)(966005)(44832011)(31696002)(4326008)(478600001)(316002)(16576012)(110136005)(54906003)(38100700002)(186003)(36756003)(2906002)(8936002)(5660300002)(8676002)(956004)(2616005)(26005)(66476007)(7416002)(66946007)(31686004)(66556008)(86362001)(6486002)(7790200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEFWQ0daMGVhSkJ1RG5FRFUwV0RKSy9wc1prclFEcmZ3dDYxU29VVDdvQjQ2?=
 =?utf-8?B?d0hKaWY3b3BBSE5zanY3WkFNNW1xNEdZazFBbGg4LzFtZUxrUmNINW40WWlw?=
 =?utf-8?B?RmhvVDRJRm4zaFl4OG10NG5qUlZHOVRoT1RuTUZqcE1kT2M3MzRqVUJLY2Qz?=
 =?utf-8?B?cTFneml1WlZXU0NrLzFSMGN5OHptclB1WjFaSmJGZ0NoMFBSc1VEa1JiWUZI?=
 =?utf-8?B?OWVUcmRlY3ErMXA1Sm52ZkpNQzJvbTVKdzFURUxINjBDY0JTQldaY1NVUk1p?=
 =?utf-8?B?YUYxV3l0c1htak9PSGUrdGttemdYb3p0ZjNyU1Z6SzE2bVVKK0xaKzRyWTNk?=
 =?utf-8?B?OFV6alFiWGNadG56azhLOW9pNjEvNXIrbVNEdUtoRkdwZEw3WGdMMjdkeTlp?=
 =?utf-8?B?NGZaeHJOWEdiU0srZ094R0xBMzRoYUxDWFRhU2RPU01aM1gvVkhBNWt5VlZX?=
 =?utf-8?B?bzZSS1hnSzBxWFpjSTZraEdBZS9HZWJtUG9LbE55Wmsxc3d5QTRHYjVvRkFt?=
 =?utf-8?B?MVRCdUtrTDA1bjd6WlhZVllwbzNIMHdvdFhJS05Rc0VITkthb2pGRVI0aXdu?=
 =?utf-8?B?SkpuS1BDZVBtRUF1K1VIdGdpTWZoNzZDQWlCY1M5TkF4enFpZW5tN3FvUWxm?=
 =?utf-8?B?QnpYbGp4UDI2cFdPK2U2RG5teFNCMy9zZzNSUmg2bmt3ODF3dUoyMGlCenJl?=
 =?utf-8?B?TXh2bVFiTktLbllwSkJjVVdEUURSV0Exc3B6SlpCeDd0dlk1QVhCaEZHMkx0?=
 =?utf-8?B?K3dLdkx5b2F6cStWN2dER3ZaR2hQRmVMTXNOR09MZG1ZZjl3SDNXNGJ6S3Fv?=
 =?utf-8?B?NE1VMzhGZnNYSjlob2F1YkVKYUdzV3JSVlkvS0U3ZWJjQ2swM3dWYTRpZjYx?=
 =?utf-8?B?d1AzY3ExdWJkdUpER0oxWE1nc083V2ljdUR1bDBJSHRzQ1Ayb3BUdUdNVmVS?=
 =?utf-8?B?bkFRNlN3ODRGUWxWSTFsVVp3VVdMSmhrdXNwMTBpSkZoS1ZkV2R0dzd4NlRs?=
 =?utf-8?B?eU1VaW1DbCtHZCtBV2tnWVVrWjRIYUxpOFFtU1B0czh0TGdkZjd6NDRQUUV4?=
 =?utf-8?B?S1VzMnlsOFJ2UlFRcGFZSTJxT2k2alpGV0xqemgzMnhvRDBxY1J6ZUMvQUts?=
 =?utf-8?B?b1o3UCtiemZUVXo0NFZkUUxOU1pvejNYMXhKRmdTTWRic3pMMk1uZ1FxRml4?=
 =?utf-8?B?V1ZNNTV6VFdsRWFPQWNURWNSZ3luNDF4aUlxQ3IrSmhzYm4yUVlqUDdmbllE?=
 =?utf-8?B?RUYzNE5wdzMvcWFaV1IybnZXOUtGcTkwZ2pPTGhIL3JtRmkvdUMrRkEyZ2sw?=
 =?utf-8?B?L2xiRTJ6Nmpvc2x4ajBmUDB2MS9hY0IyOTJSMUFZYW00SXZ0elhTRS9XbFl5?=
 =?utf-8?B?YmJySzhzWHZJcXh2bDJDS05MUkNjbUREbGJZVjNjTGxrNUVVWGdoMlZzR0NW?=
 =?utf-8?B?SWxzU1FwNXllN2UxU29Hc1E1dGVwMGJndGZ2V0tMUjlWd2hOZzBmSnRBSHlx?=
 =?utf-8?B?dkk4eXZvZ0U5Sk5Vd1YvWlNmU21aVDlzTFg5WDEvdFdGTmlPNEE5OWkxNlVZ?=
 =?utf-8?B?K3BKSTd4Ulp6dVhieWtpcjQ4SmgxQzh4Y3BJYSswck9aTkU1UkJGYm5FaE43?=
 =?utf-8?B?RXVzWHV1QlJYem9vVXhVSFNqS3pLdk1KbFpIOWIyUStTYlJPcWV2TSswMmsv?=
 =?utf-8?B?Yks0cVUrSVhWUVlIZzk1TUsvbkpYNjRtTkNwWDdYMll1NWNGSUREZ2RUUzU3?=
 =?utf-8?Q?knwGxC9wazi4uHfbK/MG97wTyOjdPU+V25ubMsb?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12fe66e6-af1d-4e1d-8204-08d97cca555f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 06:37:50.9515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v+8rD9/6nlJ2ia5hvQk2thzAXNpLOqcbQJspT1SKT3rKnEkmaLfLh4T6wHVHjXDDVVPnEE89EJ57CFH/hld1KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7059
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zixuan,

On 9/21/21 5:58 AM, Zixuan Wang wrote:
> On Mon, Sep 20, 2021 at 6:26 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 27/08/21 05:12, Zixuan Wang wrote:
>>> +
>>> +/*
>>> + * The UEFI spec and EDK2 reference implementation both define EFI_GUID as
>>> + * struct { u32 a; u16; b; u16 c; u8 d[8]; }; and so the implied alignment
>>> + * is 32 bits not 8 bits like our guid_t. In some cases (i.e., on 32-bit ARM),
>>> + * this means that firmware services invoked by the kernel may assume that
>>> + * efi_guid_t* arguments are 32-bit aligned, and use memory accessors that
>>> + * do not tolerate misalignment. So let's set the minimum alignment to 32 bits.
>>
>> Here you're not doing that though.
>>
>> Paolo
> 
> Hi Paolo,
> 
> Indeed, I checked the original Linux code [1] and it has the alignment.
> 
> This patch is from Varad's patch set [2]. I can update this code in
> the next version if Varad is OK with it.
> 

Please feel free to modify the patch in the next revision. The alignment
indeed does not make sense here.

Thanks,
Varad

> I just finished my Google internship and lost my access to the Google
> email, so I'm replying with my personal email.
> 
> [1] https://elixir.bootlin.com/linux/v5.14/source/include/linux/efi.h#L73
> [2] https://lore.kernel.org/kvm/20210819113400.26516-1-varad.gautam@suse.com/
> 
> Best regards,
> Zixuan
> 

