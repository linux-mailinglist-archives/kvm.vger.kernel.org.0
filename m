Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A63B4C27CF
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 10:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbiBXJOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 04:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiBXJOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 04:14:50 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EBD1B8FCB
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 01:14:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645694059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1y+Jrw+2eTe4y2cpGX3a1qwOdBMzRjM7IetV05vD+c4=;
        b=n89nqvIepyFO4ATnDbgbtQnAmZsffzH283oEMmbJTZD25qmNqXJ3bTwechMmJeHGXhHfi6
        wvqhlKZFU+NzJDMLpJ4H3CvML1K/Rw45WJxgJiR9mEgQyCK8+E4o0opwGyScNB72rAPVWb
        Z90kahMdxkL0CNTTHIyIvRbRoIFKkuo=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2055.outbound.protection.outlook.com [104.47.9.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-16-pVsr398wPtaq2PXGQSoqzQ-1; Thu, 24 Feb 2022 10:14:17 +0100
X-MC-Unique: pVsr398wPtaq2PXGQSoqzQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHh599UmD7xN/XqC5D24ASF8TvB2JompCVLkbGbQ1+911mFBpPRDlmozKnTdQ1UAGBw056BjMH/CK9ZKSZ2771sMZiHcXLkQ3QIznxPIAo7jkLQbyq+kvOca5d5UW1HY8uBFpF00IWAkS6hQgyRjNMTKLz0gxb/h6sHvly+bRUkn8WdQhvscbAIlq/ODAXT4fSI8vQVnC2uExsBQqUgMXSP4NgnPyqNuk6CzKFZeSEFPQFrXjj/0vqLoQYyTBJ1IXyQpLljC4OSBDX/qG1oo2nv8SBufZyrxgweiOUQ/vgi7gqUNK/th/k2AHZXn2Vb6xB8+PSxJ08agUa0+U/m9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1y+Jrw+2eTe4y2cpGX3a1qwOdBMzRjM7IetV05vD+c4=;
 b=iYSYtpOms1Vfgv/TOMl3qHsoLXwvvKfcCOluwGFMEo4KCAgUfgarpxJmsuUMwcfsRRjblSky7EaUBXWP3FFeM5vkMzjjbzvjWUNqptMS13p0WGX15S3CnPz6pXtYJGlQTKu4aQ9XFHFCrYRGhtamlgk5aTwfE30kYkbw3e9rqb7sU+m562sAzsHprBSHpvAeW/Jtw+u/yPn9ejk6rqdPLgu539u9oHy6RP2gVKtQuilK+FsYhYS0ypvWEukAtQqsw3cJOX8rEAbk6K4755WUXKAWrhV6ATSQ65iYEj63dXzZkhDVzaUpwmnjRe9umtwtAqIESpWAvSj2SfvDTWwSog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by DBBPR04MB6155.eurprd04.prod.outlook.com (2603:10a6:10:cb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.27; Thu, 24 Feb
 2022 09:14:14 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::59d3:d855:d7ba:16b6%5]) with mapi id 15.20.5017.024; Thu, 24 Feb 2022
 09:14:14 +0000
Subject: Re: [kvm-unit-tests PATCH v2 03/10] lib: x86: Import insn decoder
 from Linux
To:     Marc Orr <marcorr@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Zixuan Wang <zxwang42@gmail.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Joerg Roedel <jroedel@suse.de>, bp@suse.de
References: <20220209164420.8894-1-varad.gautam@suse.com>
 <20220209164420.8894-4-varad.gautam@suse.com>
 <CAA03e5HGyxUFQqp0BhiN6c7zEZc4qcAjb=FEpNo1XX1L_3Aa1w@mail.gmail.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <b25acffe-4738-acf3-2df3-e60e34963d0f@suse.com>
Date:   Thu, 24 Feb 2022 10:14:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAA03e5HGyxUFQqp0BhiN6c7zEZc4qcAjb=FEpNo1XX1L_3Aa1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P251CA0007.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:2f2::7) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14f39926-7012-46df-5f11-08d9f77606c5
X-MS-TrafficTypeDiagnostic: DBBPR04MB6155:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB61555907E4A887E23878E3F2E03D9@DBBPR04MB6155.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ItV57ZtuA0lU/qS0QiF8SngUcq8vEP46urXKjf4ByTVPSdGhv56ZQblpS+FCoxGLn7jmW1XBoa3KUV1KVH7DKF8yzGw4zfk2oUKC6/6/3MP3CFkEfiNg/TnTRQw8GZuj228m+cAbkJbdjOFxIU5qgAWwRng2f6fmXUWp3Dd/F6J4b7HFRZm1jZjsYMxDJNj/Ujdx4iO1JQ/Si/JjUAL8JSiBAXieqsd17N+EWK1pj3l2jteOutysDkTCWt5m8wVOFwpX2+eTa92jUoZCypE/mAFMtdGbQddAQkzrDEXDruRHfsLwSmr2cx+io95BJurGYbVK5sVv6+OE6VNYB+WdO9TVxrnY9cYtnoGAwGriWGxDUcfaQ4nhswjijbcu7c84NVgmLEWq3h8NVWFBt78v+K5Utr5OqE0kgQmPvyXB8TMx4WPM+iqofjJvcssOrvaW2xEHzzZrnA0NVQNdpTb2lpTGbV/6Vm7zMcsgGBF/+ZZIpKPyidDcUG0bsK0ZTq4zdila+9f41ZkuOq5rg8N22MAIBeTiKVFpNZc+b7YQWw90Dyxa34yZxQWTkd5/AmEUoHo5R/d7Ep7nFPaxOOaTks6Dm5APwLyhSV78IXVH+UgKLUQ7svm0bDBONaFwvXIf0JwqSHz6Cot6Ac+f9zY6fQST6i8Q5W9VdoA1nYleg4LqY9RlExTGyyeEGoJUxkD1JulyjzMz7Uv3cDfZSlxOnXv77og9/gqX9HssKGBdzSFm+lsGVG0iq2roZAc7dp44
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(26005)(6512007)(8936002)(7416002)(2906002)(36756003)(31686004)(186003)(6506007)(53546011)(44832011)(508600001)(83380400001)(6486002)(38100700002)(8676002)(54906003)(66556008)(66946007)(86362001)(6916009)(316002)(4326008)(5660300002)(31696002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0xMUVpNWGhncEtVQ3hrK0dTbXlZa1NPVjhjRm43RVhiYURvR2VNV29EdmxJ?=
 =?utf-8?B?OGU1Q0wwRjlzcWh1UjlXdllUTExWaDFldVlDMUtwQW5JNEgxdnFjL05QdWZ1?=
 =?utf-8?B?dVMwVVZGRmpKY3huYXlManNCQmdQZXRNMHlqL3JZbmM0Z3RZaVU2cVRuMEJQ?=
 =?utf-8?B?amFNMzhYa055MkI4VDRteHBjbk1VOTJpWXhKbjNDV21kd29pOFZDSWhDYzZn?=
 =?utf-8?B?RmdZQzFUcGJvK2pMOTBrL1hVSHRBS3NvcVRPVlhtVUFPck03aStTVzJkdnVW?=
 =?utf-8?B?cG9mYWNEc2RJM09yQUluNVRLNEFuUVk5cyt4SkNFanNMWmlFVU9VSmtRUVhq?=
 =?utf-8?B?TzVqWkdYdUtEZDh3SzZpQ3FlNk5OS0JWOWhkbWVkZHdkcEVEeEpaNzJwazRq?=
 =?utf-8?B?eUllRy9Ia1U5ODVvbHZTOFlaZTlvd3QyK2dZRzNELzZpRm9UZTg0SWYya2Ns?=
 =?utf-8?B?VWlyRzI0aU1XNUJ2MEJMT0trYS8zT1VUTnhrclFORXVqRzdYZ3U4cnJRQmNC?=
 =?utf-8?B?NVN3ZVhCWmpmT0JSd2lJWHY4YkdQanV4YllWaUhKbGdabFhDM094SDcxVTZ4?=
 =?utf-8?B?ZHQ1aWtpUy9yalMyUnRIeXRKYUJhK3hESkJoeU5CTEtqbytRak1UN2MxeGdK?=
 =?utf-8?B?RUFnZ3dteUYvOVFJU3hYVUFKM3pLeE92L3VLUVNYaEJ4Y3FBNTMycWdKaHYy?=
 =?utf-8?B?NHdBMHdwNlNVbzFRdmd1emh5Q2JVRjVhdFZDM1R0T3F0QkRpZGZGVkhPa3dY?=
 =?utf-8?B?SHo0NGltNG1sekw3RjFScCtnNVBNL1Vwa0phY3luYVJjZFlZMnIrZjV2WHhN?=
 =?utf-8?B?RFJpdFJtOHVDTmF6Q1pLM0VTOEVTRU55RjAwZXpja0grNVlrRkZWRHhBbTNu?=
 =?utf-8?B?Z1FRbGk0Umx0aGpCNURDSlIwRFpkbWNESUVKbkw3SzFtcjU5S2FmQzBrUEd6?=
 =?utf-8?B?WnMxVloxL3lWUm1ZZ21SZnpIdlVDUzBMdFdpc1B5ek8yRnVFT0dVdEhRR0I1?=
 =?utf-8?B?ZmNWUE9McUhhS3lnalYxdC8rWHMxMk1DR0srNzhLMk9ZTHI0R1BmdXZrQlNL?=
 =?utf-8?B?VUZrMGRYU1BuSS9mbzN0bUdZZHQ3aEZkYnhNNUtFRXdXYmZpQkdJMWJQT3Ir?=
 =?utf-8?B?a1BTVmZqQjN1MzVuMXRBSWR3cGpNTmZ0V2N5WlBzeTc3S05hcXozemRncFlu?=
 =?utf-8?B?NFRNNVQ0dXJPOWF3U2wwQW1iN0xBblEvYk5GQ1RnTkZTNzN6RDB2NVdETmts?=
 =?utf-8?B?TVNJWXJYeXJIQ1BieEhWQTkySy9VbkYza1haSTFTYWtKamhTejlyd3h3L2NE?=
 =?utf-8?B?VzJ4WktiY1dBcUR2SExaZXVZak4wVHc4T2hDM3FIblNlc3BSRGpKQTB5QzdZ?=
 =?utf-8?B?T3IyMTVhQ0FLSUpGMHI4NUNTTEtCZEphbVpHN21iOTRQNDZVMFFiblJpWW1z?=
 =?utf-8?B?RlR4cEJnUi8yUkMyVnhLbzFNVm1PWWRJdjU1QlJIdE5jUkI1WUNGL0ZidHJM?=
 =?utf-8?B?VzdzaXhOZTRNRjlhZ1pRa21DTVRJQ0VSdHdtbUtVL3hXeTNNMzNkRnVIdzNJ?=
 =?utf-8?B?Y2cwTGYvbzVsbFp3R2prWFNmeTdReVpxUWpTajhRVm9jVHQzRnJNZHovZlls?=
 =?utf-8?B?UTZnZ2hRUm80RkszZkxBQkRYN09LQVlSVk80cUJyZTZCVVpCb3JrVE5HbTBE?=
 =?utf-8?B?NExENkxzeFE2WVRoQUZMbitjNjhXMWFFcUpyYmU3WDBUYTZGZlRwSXRucnJI?=
 =?utf-8?B?QVVsUFpMUnhMMEswSVBCUTROakIxSFdKSitMMnlPM24wU0EwTmF0cUlNWFJh?=
 =?utf-8?B?YlNuMzMzaWNLRGdxa1NRS3dwTU1ubnRINmhqbGpmV0VrUmVodzF5S3NCTUZr?=
 =?utf-8?B?VjNUK3YwWVQzdUxXQ0pOV3VQMmZVelUrdTM4d1crZFZSYW50ZUh0WUlVems0?=
 =?utf-8?B?aTJVd01aSE9rSVNPaXdmNERmdlhFaWQzKzg2SWk0S09lblEwcC9NSFlDQmIr?=
 =?utf-8?B?S0d5enZGcEJ4OEhRV0t5VnBrQVk0MnNHaXRNeTdyNGNZVzFBdXcwZHhjU3Yx?=
 =?utf-8?B?M1RDSllOcjRaNklVTG1sSVh5cDdsSkZLVHRMSkN1MlRKdnlOcWJQWnkyL29a?=
 =?utf-8?B?cFY2aVAzRU40TFg5M1NCRkc3a1dDQVQ2TTdrUDQ1b0ZjVFFHbHBXcGVrNkVo?=
 =?utf-8?Q?hHyRuXwSUYtyUJTTeITcefY=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f39926-7012-46df-5f11-08d9f77606c5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 09:14:14.4247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 83+Rum9HD657YuOPr7HVZxdKlC2NLlB8MIzrFdNWVk0vz+MLnmVo3fSb6CCZ1e/weNf3gp2hGfmyzPeeZiFYvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6155
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/12/22 6:42 PM, Marc Orr wrote:
> On Wed, Feb 9, 2022 at 8:44 AM Varad Gautam <varad.gautam@suse.com> wrote:
>>
>> Processing #VC exceptions on AMD SEV-ES requires instruction decoding
>> logic to set up the right GHCB state before exiting to the host.
>>
>> Pull in the instruction decoder from Linux for this purpose.
>>
>> Origin: Linux 64222515138e43da1fcf288f0289ef1020427b87
>>
>> Signed-off-by: Varad Gautam <varad.gautam@suse.com>
>> ---
>>  lib/x86/insn/inat-tables.c | 1566 ++++++++++++++++++++++++++++++++++++
>>  lib/x86/insn/inat.c        |   86 ++
>>  lib/x86/insn/inat.h        |  233 ++++++
>>  lib/x86/insn/inat_types.h  |   18 +
>>  lib/x86/insn/insn.c        |  778 ++++++++++++++++++
>>  lib/x86/insn/insn.h        |  280 +++++++
>>  x86/Makefile.common        |    2 +
>>  7 files changed, 2963 insertions(+)
>>  create mode 100644 lib/x86/insn/inat-tables.c
> 
> In Linux, this file is generated. Why not take the scripts to generate
> it -- rather than the generated file?
> 

Sounds better, I will generate it in v3.

>>  create mode 100644 lib/x86/insn/inat.c
>>  create mode 100644 lib/x86/insn/inat.h
>>  create mode 100644 lib/x86/insn/inat_types.h
>>  create mode 100644 lib/x86/insn/insn.c
>>  create mode 100644 lib/x86/insn/insn.h
> 
> I diffed all of these files against their counterparts in Linus' tree
> at SHA1 64222515138e. I saw differences for insn.c and insn.h. Is that
> intended?
> 

The diff is because I needed to fixup some of the insn decoder code to
build here (eg, include paths, unavailable definitions). But I see how
that would lead to confusion whenever these files need an update, and
it's better to minimize the diff.

I'll go with taking the insn decoder code as-is from Linux, and try
keeping the requirements into an additional .h that glues the decoder
to KUT.

> Also, should we add a README to this directory to explain that the
> code was obtained from upstream, how this was done, and when/how to
> update it?
> 

Makes sense.

