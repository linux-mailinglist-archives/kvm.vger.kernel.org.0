Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F4463F88E
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 20:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiLATqW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 14:46:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiLATqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 14:46:17 -0500
Received: from esa4.hc3370-68.iphmx.com (esa4.hc3370-68.iphmx.com [216.71.155.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED1D2034D;
        Thu,  1 Dec 2022 11:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1669923975;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TQcZLvVpPz/Ye5XGo/fj0BNwfD4+Bsgqe6ZCHbiqZNM=;
  b=WCHsoNPoWs2zMrqtQh68Z5a2IT8C/1ICHl6fnbZNEUgSwhZGfIeVWkk8
   8EmgDxko4iyubQzK2qzt9aF4ElMWFnPiBggHH9oY0gi/O0vmE6V6Lkg29
   RcyJJtlGZcThRN/GuPSCC+Z3LFgxaUWLgpIp0gIPWhjPiC+y8x/bzrWqO
   o=;
X-IronPort-RemoteIP: 104.47.73.175
X-IronPort-MID: 88657210
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:2vYZuqL8JtLIYyjCFE+RcpUlxSXFcZb7ZxGr2PjKsXjdYENS1DFWm
 jEbX2mAPKuDNmP2eIokYY6x9EwGuZPVy4c3TVBlqX01Q3x08seUXt7xwmUcnc+xBpaaEB84t
 ZV2hv3odp1coqr0/0/1WlTZhSAgk/rOHv+kUrWs1hlZHWdMUD0mhQ9oh9k3i4tphcnRKw6Ws
 Jb5rta31GWNglaYCUpJrfPdwP9TlK6q4mlB5ARnPasjUGL2zBH5MrpOfcldEFOgKmVkNrbSb
 /rOyri/4lTY838FYj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnVaPpIAHOgdcS9qZwChxLid/
 jnvWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I+QrvBIAzt03ZHzaM7H09c57XzFS7
 PUgawooLSKevL+u+6yZFuNj05FLwMnDZOvzu1lG5BSBUbMDfsqGRK/Ho9hFwD03m8ZCW+7EY
 NYUYiZuaxKGZABTPlAQC9Q1m+LAanvXKmUE7g7K4/VspTGMkWSd05C0WDbRUvWMSd9YgQCzo
 WXe8n6iKhobKMae2XyO9XfEaurnzXOlBd1ITeXQGvhCsG+B/zYdMxYvZF62h+insGv9BNBwJ
 BlBksYphe1onKCxdfHmUhS+onWssRkbVN5dVeY97Wmlw6vXyw+cCi4PSTspQN84secoSjEwk
 FyEhdXkAXpoqrL9YWLNqJ+XoCm0NCxTKnUNDQcATA0Y85zgrZs1gxbnUNluCui2g8fzFDW2x
 CqFxAAgirMOy8QWzKSh8FzLkhqrvJHCSgNz7QLSNkq56QVoIoq4bI+A6F7H4PIGJ4GcJnGdv
 H8BktPY6O0IAZiGlz2lSeABWrqu4p6tLDLYkXZrHp886y6q/X+zO4xdiBlmKVtkKNQseDnne
 kbftApdophJMxOCdaVwZZCwDcUC16XsFd35EPvTa7JmeYR8bhWG4D1GakmX0GTg1kMrlMkXP
 JaQcc+hCTAADrhn5DOzS6EW1rpD7iU332LUA5T6yhOh2ruTYHqSYb4APB2FaeVRxKaFpgrS2
 8xSO8uD11NUV+iWSinc+KYXLFYXPT46D5WwoMtSHsaMOAdpG2EJD/7X3KMvfJFjk61Jl+DOu
 HanVSdwxFPhiDvHIAORZ3ZLbLLpQIY5rHQnMChqNlGts1Apea6m6KYScctxcbRP3M5q1vlyZ
 +sVIc7cRP9IT1zv+ywURYvssIt4Mh+sgGqz0zGNZTE+e9tlWFbP89q8Ig/3rnBRU2ywqNc0p
 KCm2kXDW50fSg9+DcHQLvWy01e2untbk+V3N6fVHuRulIzX2NACA0TMYjUfep9kxcnrrtdC6
 zurPA==
IronPort-HdrOrdr: A9a23:Mp+LWK4AjfqVlMdFlgPXweCCI+orL9Y04lQ7vn2ZFiY5TiXIra
 qTdaogviMc0AxhI03Jmbi7Scq9qeu1z+853WBjB8bZYOCAghrlEGgC1/qp/9SEIUHDH4FmpM
 BdmsRFaeEYSGIK9foSgzPIXOrIouP3lpxA7N22pxgCcegpUdAY0+4TMHf4LqQCfngjOXNPLu
 v42iMonVqdUEVSSv7+KmgOXuDFqdGOvJX6YSQeDxpixBiSgSiu4LvaFQHd+hsFSTtAzZor7G
 CAymXCl+SemsD+7iWZ+37Y7pxQltek4txfBPaUgsxQBiTwhh2ubIFBXaTHmDwuuumg5Hsjjd
 GJiRY9OMZY7W/XYwiO0FXQ8jil9Axrx27pyFeej3emi9f+XigGB81Igp8cWgfF6mI71esMk5
 5j7ia8jd56HBnAlCPy65zjTBdxjHe5pnIkjKo6k2Ffa40Dc7VcxLZvvn+9Ua1wWR4S2rpXV9
 WGP/usosq+tmnqNkwxi1MfhOBEmE5DRituDHJy4fB9mAIm4UyRh3FouPD32E1wtK7VAqM0md
 gteM5T5c5zZ95TYqRnCOgbR8yrTmTLXBLXKWqXZU/qDacdJhv22tfKCZgOlZaXkaYzve0PsY
 WEVEkduX85ekroB8HL1JpX8grVSGH4WTj20MlR65Vwp7W5HdPQQGa+YUFrl9Hlr+QUA8XdVf
 r2MJVKA+X7JW+rHYpSxQXxV5RbNHFbWswIvdQwXU6Iv6vwW8XXn/2edOyWKKvmED4iVG+6Cn
 wfXCLrLMEF9UyvUm+QummkZ5osQD2LwXtdKtmowwFI8vl9CmRliHlktX2poseWNDZFrqs6OE
 NjPbKPqNLImVWL
X-IronPort-AV: E=Sophos;i="5.96,210,1665460800"; 
   d="scan'208";a="88657210"
Received: from mail-mw2nam04lp2175.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.175])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Dec 2022 14:45:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lB/Bgzoc0JVXMtRjM/7bxpTOHPS5cSbN/HF+dQMuBDriL7xp1LlyH3ewf0nBCMs6pXiC8zi/kT7ejd7hcifxSHYQnGLqmF0+BDllx1dHVGrt4z3q4in4cz7a9yPxH34zkcC7nMFnBxuPi93ZHE8L72jwkVcKIhgDIuFuyFR2O21srQFe7KQ9K2+CjYxuqCglo5PzuIAENGi+4uocDdBpC8wiAxU4Pzl5JYhINLiUO3cBAtUIqZFow44Fkl0SH+k83a7y7pcPUPxPisSknX3Xv6ssf+PWPhiN6A6j5lZQFB3dYtKan8H752J5X/AJpO03RS0S7VPT7KoPo2QwUgwg4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TQcZLvVpPz/Ye5XGo/fj0BNwfD4+Bsgqe6ZCHbiqZNM=;
 b=W86KzVGKpDC7kht2oQu+3GAgyzN84UPwzG464HZaCfjrkIIdC02rmPL7t2Fe6/fAl5k7hnO7HZ0RfiGJWFuTIXPI1omDaUmEWZ3ycg3V8KW0D+n7LghvbtZmoGalpciX1qn78/Ufei51+FWbXk1RF7pXC3lwMiudu9GlS6HTM61eM03buH360qCHABEuVcIy71y3PTtb86mQ4FnmkyypWLOEvZOu9ngPnywzHITsvQd1brB65ZQtr/k95vTcWyCEAf1Fijo62pou3475RpAa75CyukmvROWt8a3H1VJIFs7u48iQZMhGoHbue0XdQbStIqTl0GmvNJkZT2NIxQYMlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TQcZLvVpPz/Ye5XGo/fj0BNwfD4+Bsgqe6ZCHbiqZNM=;
 b=RobTQVy64AqrZk48H4OGTLN0tRfSIiewGZCfGAeK0vU7CVziVpjUHhwLWpyZ0W6JEfY6EHbGGWHFmqTxBJ+nzFEOPqKAG17KApeiqoS6WpqGw+JhZKIi5FgV0W5w8g3a0Vgl1y06zNYO3Yl6Ot91D5kkxUuiO8gigQPGjN/7i08=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by DM6PR03MB5162.namprd03.prod.outlook.com (2603:10b6:5:24a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 19:45:54 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::c679:226f:52fa:4c19]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::c679:226f:52fa:4c19%6]) with mapi id 15.20.5857.023; Thu, 1 Dec 2022
 19:45:53 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Sean Christopherson <seanjc@google.com>,
        Alexey Kardashevskiy <aik@amd.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Sterritt <sterritt@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH kernel 1/3] x86/amd/dr_addr_mask: Cache values in percpu
 variables
Thread-Topic: [PATCH kernel 1/3] x86/amd/dr_addr_mask: Cache values in percpu
 variables
Thread-Index: AQHZBSuITuOg4qIyhkioJOkt0tINEq5ZQdcAgAAu3IA=
Date:   Thu, 1 Dec 2022 19:45:53 +0000
Message-ID: <61fd3a98-5ce4-beab-a5b0-699d529c4f3f@citrix.com>
References: <20221201021948.9259-1-aik@amd.com>
 <20221201021948.9259-2-aik@amd.com> <Y4jdIl1elcnL8JUU@google.com>
In-Reply-To: <Y4jdIl1elcnL8JUU@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR03MB3623:EE_|DM6PR03MB5162:EE_
x-ms-office365-filtering-correlation-id: 417876bf-8b30-482d-b1b2-08dad3d4a870
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Moly3ai0bvYcf7Ss6O4vM0PnMTX2xkK1ZqbKF05bWm7mdc2AU9Yb/HfYM7/2FraCN3/S/brZsWrBkUYDbUAwgj4JnRFyrt+ujiLBHDJuTHg0wn4jFHEzdTOLyexYHUGn6H2UF8x5zlob1CoTdmrXgoyAVOyiHJYZpysCuIT4ngGz77nJS0qqR87mh+9Wb8C0zsbBH4gSKQAQuuPZ1UmfLQAmoNJYY7UxxhUX2IPDgmFrTQexJ7ipLCVSlWTAApQ0+rnXBgzZh3Jr8dyLQLnf069gCMLo5sVn9D+fWJbvCHAwb7jQF1Wykg9TxeJ1dSPY/peCMnZrRW08ugPzbwzQmzFS4VQ7R9yf0Drb9GMclhJLBoFVu+zvWAe7kusoZd5zZgiicieoqJrMSt5adVnouJ1AzFrPVzJ7W7XU6F/CNCU4u9oMglnOLCiWj4xhTNye7t+tykZUiPeHDyHuNvPezFiqiZgHNqM9lrCMpncy00SQ4OVBRI5G9vn9bTGnFiccTgrNh1kApW6IHeXeCob6lt5hYYueaZQNTaiN9KBs4Tiit2lWqEJd8inxsg8H7xWTe09JnG+zCCLwMWMANKNnKx3KTFDX3NR1CSiFwuk5mI3Sj5f1dzjgJnPDrYtmu07svoe6r1K18pzNRz8lCOrwE8lqpMt6fJR8+xQMKONe5dEVUaCO6NB7w0UzVA3A9qXg+uI8AdygZv5NajP80ateIPJkveCHjuOIopygVAVMmD/PI5Et6ruV5xQtqIYqidme4cvAQujFsorxLz/OhDV/9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(64756008)(66446008)(4326008)(66476007)(7416002)(316002)(186003)(36756003)(122000001)(107886003)(6506007)(8676002)(5660300002)(71200400001)(53546011)(8936002)(2616005)(86362001)(41300700001)(110136005)(54906003)(82960400001)(31696002)(26005)(38100700002)(6512007)(31686004)(2906002)(6486002)(91956017)(66556008)(478600001)(38070700005)(76116006)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RTZ4NGIvY1NpTm5oczBjRXpmSDVWVEhyY3BYUndWZzZscXFQNyt0T1o1MUFz?=
 =?utf-8?B?aGhDNlJSNGJ0SzZXcksxV2NCUGtZUUhzOTArbFJjVTcxTmQ2bUFJUkRMMng0?=
 =?utf-8?B?OVdOdFRKZWdVNENmd0MrdE9VREt6a2hmR0VBdkhYU1ZkOHRuWVVxS3hkSSs1?=
 =?utf-8?B?Z0FlNUtKcGNFVDUzWW5vOUdTWXNVT0xVWTVQd3NQSEx4aG9sVVNHZ0RRaEQ1?=
 =?utf-8?B?NTZRYWJLRjBzVWZkRUN2a05BRWd6cUhCaTlseWVrUDdoUU4xUUFiT0hwQU9U?=
 =?utf-8?B?ZkFGMk5DR2JnTm1XaVVTL20reW1pdXRnNmt6bUp2enc2eGFLdG1YSnVYeWdP?=
 =?utf-8?B?NFpYblFqSDdUYTh4d1pDMnU1ZDZnWkN3RHJkNDNRaEtBdWh4MFlxRW5nQWo5?=
 =?utf-8?B?ZGEzWWx0eXMwdDYvaXJ5Kzl1bnc4OHJ2ZEtCVlpBTGpMNzEwOUhDckR3dlVS?=
 =?utf-8?B?eThUd1hRUmgxaktSaEh1Y0VnWU5jMkxkZFMrSHFEZ1puN2JBck81NzFuUW0v?=
 =?utf-8?B?YkFJSUkvU0pxbmhBOGFPamYxd2NOY3F3eHNBMklVM08xQ1grbnA2K0F5b1Zx?=
 =?utf-8?B?b3hma1A4eERtQTVYeEZzWjVlclNhWVkyTHNIa0IxTG1jWGNqVUhLMDYwak4r?=
 =?utf-8?B?VFZrbElIUUdERmF3Qk9qTGlWNTBDRmtBcFVxbVdDTUxkcjF6eHhjNll3Z3VS?=
 =?utf-8?B?dFRjeFNFQVdWYUIraXFrT1ZOK2J0SWwvOWZ0V051MXVNeXYxNTErWU02ZktZ?=
 =?utf-8?B?MmI4cThvT2hzSFVxR29NdkUxUVB6RVVZN0wrb2dUT0VpditOd1VvTDM1WnZZ?=
 =?utf-8?B?Nmw0Z2R3K015ckdMbHhYT0NqS3pjV1ZETjdJZThNZDE1OHp0Si8rbnRsQ1g4?=
 =?utf-8?B?dkUwY253SmxVVEYyVERsdENnRkR6aXdHWTRvRXoyaVR6dWZyMzUreUh2L1RW?=
 =?utf-8?B?ZklEUFBILzFKYlpxd25TcHNmVFVidWVmenFFRldwR1FXV0xhQWQ4R01vRUtr?=
 =?utf-8?B?b21WSS9hZjVKVzZFeXl3YTl4NFduZzRQYzNQd09PWUNZTCtJeUNSZlhwWDRF?=
 =?utf-8?B?QmJaYlhZT1RzeU41Y2VSRXRxSW5Ic1pJZHpvbGxZLzEzU0htMXFybzRmWWVl?=
 =?utf-8?B?MTVZL3N5U2ZEc3lWVkZxS2ZkcHdZSVk1dG5TY1JNWC9IWGtGWFJsekhtVHF6?=
 =?utf-8?B?NjBXc25FUFBHNEpocTNQanlXL1FPa1hITmhCTXRyc01FTDdlYUZUYTJLK3hK?=
 =?utf-8?B?a0dFaFFURnhmSmg0WDQ5VFA5UXdraE1zczJvUEpYRGQzZUlmdTltSHNQSURp?=
 =?utf-8?B?SE92LzNnYXFwdlc5Zi9pVFBRWXg1VFNTNG5sK1V3a3RFaHptRURYMVhDUnpz?=
 =?utf-8?B?VDZsRkdWcUVpQnVQL3Y0a3dvNnNkOFlLWVFkaFJaM3pQSEVDc2wwaDNwMXp5?=
 =?utf-8?B?UEdGTGg3eDRySk5td3JjVDUrWnBWMGxmMjZ0S1dDMExIak9ETHVIWUVJcUhy?=
 =?utf-8?B?amsyN1lsYWpTb1dYclR1dlp1N01PT3hIc3o5YU1MR2pMekNQUGI4NU9kd1E1?=
 =?utf-8?B?RWxWMitaQjR4dXNFdHJSSWRlejhMY0tWYjBWQXM3QU9WQ0Y3T3pMZEx2YUZQ?=
 =?utf-8?B?RWRjSnp5aWV5ajVSOEhjU21RZTNGK3YxOXB4a3ZNeFlWbGk1dFZRMWt3TFRz?=
 =?utf-8?B?bDRIV1JqdElhaVlQMUFmbXgySzllM09EMFZRNkpBMVAzVzQ3TFdNeXdDZHU5?=
 =?utf-8?B?NW5vSGk5ZFpRd2ZRd2FkMDBRSDZNVE9ld2dhWllDME5ralBxV1p3OVlHU3pU?=
 =?utf-8?B?R1RMbHAwenZNeW9UcUJ1YTVSVTQvVTBTYTdtSEMwNzdadncxb2dicmtUNDE3?=
 =?utf-8?B?K3Y3M3pyT0VLMkw5NkIwU3FoQ3I2RDlLWmxiWkhvUDN5TjNRTXU2aEpFUU94?=
 =?utf-8?B?Y2t0MVpXRWw0aU5aL1YyclBSRk5jck16ellTMWZhS2pnNXBsZm1rSS82ZWJr?=
 =?utf-8?B?Sm9XTEUvZDFjQ0NmWEh5NGk0ZEhYTjZSWkVSaE1XTE1VNXFYWDNiZUhUOHVk?=
 =?utf-8?B?SU9vTHhOMHJET3FlNDhqam5xVjNnb1RQTGM4RFMwZmc3dFJuMk1Hb25KdktS?=
 =?utf-8?B?UFdyT2x6L2pHTjVYWUNlOGZzVy9QUTRLWUNjc25SQUtvVW05MU4wVFIzdG9Q?=
 =?utf-8?B?TWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5E09DE174A67A4ABFB5216F833CD0E9@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Zm5QZ0w5a21ncEttRFlpSzl2emZsc2ZZS2xReHVNVXgwS21CbWNDUkZiMFBG?=
 =?utf-8?B?QjZ0M0ZyekxubzJIcVNiOEppamNlK3dNLzE1aUU2YkI3Sml4UUVOaCtJNWVZ?=
 =?utf-8?B?ZXFCaUpwMmphTEI3QXR2K0xaMmxKUE1BV3BlNmtzNlZGQjBOTE9Za3RwMm5T?=
 =?utf-8?B?dWx4eHA1TDJMSXljQXZadU9sSnB3aTVHSEFKOFFrVWVEMENqNzJSQUhMY1hQ?=
 =?utf-8?B?aHV6bWtKaDhGS241UGgzdm12aVdrVFUvc1MrUll3L0x1WnhFUnNpb3h4aHAx?=
 =?utf-8?B?bWZSei9DcENoMWgvTWNSeUp0Z3Q4cFpyR3ZQczVVb004VUxCcm5SNEk5bHRy?=
 =?utf-8?B?RnpXMWpnOXZodlFpS2JuenRXOVZmTEpDRXdsUm03RnBjeWduZGk5VlhpKytj?=
 =?utf-8?B?eS9OcXk1VUszM0w4R0toa254WXFNOWZKeVJDYmpmTHZtNVIzZnFrdGNSZE9E?=
 =?utf-8?B?QjcwZTZ1UHFCUkNXQmVGU004RjVUOWtqc2FNRDVjMWZXdk1seG53S0IyYUNW?=
 =?utf-8?B?N0YycTVGTWJweVNLZmdBNHV4bE8rNU9TcWllT01ETzQ1VUJTaE15YW5pRW8v?=
 =?utf-8?B?N25neUxWNCtid29STlpPZTNvRUhUM3R5bVR3V2M5aXhFVzF3R1V6dWhwTnhV?=
 =?utf-8?B?SWpiQW9USVhuZGxjQTRiTEt3cmxTSzRqVnlyZ0hYbTd6MXJMaEd1MVU0OVNS?=
 =?utf-8?B?RDVyZlpId3pwMWRTZ1Bya2NycVF5R0xBSGRRdWRrTWpxeThncXloRmFCaEdv?=
 =?utf-8?B?V2NjSithVnBpakl5dFM4eEZmY2lOWmdUN3N1U051NU53aktRdW5lZnkzcXVZ?=
 =?utf-8?B?cGRXVXBGRkp2aGgwZ1RvWUJMYWtLSDNMQW1UdGgxV0h4NzMrSTlwcStlYWRO?=
 =?utf-8?B?bmlvTVd2N3M4Zy9uL0E5RU5ZQmdYeFlHalBHdDVpMnRSbEt1T2hiSUEzWFJC?=
 =?utf-8?B?MXBpT1cxQlRkdDVNb1pOUlBBd2k2c0FKek55Rmp5OW8vSG1TQldsMEU0ZUR4?=
 =?utf-8?B?ai8zeFQ1NjVlUTNRaklEYWdGWGFMTE53ZS9wRy9yTVRzeTdNa1dmUkFvZmxx?=
 =?utf-8?B?YUw5K0pQT2hyOVhSSGJjblVPMDdvMk8zUjN0cUxtc1NMSlRmakx6WDBxL3Vw?=
 =?utf-8?B?RzRjNSswZHJxWG9yYnc4YjBHa3p4bWpsTGRXeUVDc211ZDBHVVZGbWU0Vjlx?=
 =?utf-8?B?aFk4RC9razlJY04ycWtqNHpHSmQya3lBOGNFZHF1R0M4MGRCMjFVczNKajQ4?=
 =?utf-8?B?WjR5RTFZWWM0Z2t0c0paWnVuSGt1ejV2N20wOUtUQU5qMzhGb2lGdnhwNkhm?=
 =?utf-8?B?YVF6enZ0emVyOUpNb2kzRTY2eDdNK2JEQTgzenI3UFA2bEhESFZXTUpRYUNJ?=
 =?utf-8?B?Lzc0NEZCaENuZURtTlFtU2YydlpRV3RxUHRIclVkekE5VmJiMTRKSDhKeW16?=
 =?utf-8?B?SE9sWjY3eVVQaE1WdGx1dk9SaWtpWUxFbnpIMmZmUHRZVnFTNVZwQjJFVE1G?=
 =?utf-8?B?RkRGWm1uNEZKQmVsRGNrWisxS3FnYjlJcWhORW1ESEhzRmZtZGExaVdxSU9v?=
 =?utf-8?B?TGUrMGdoQjdzSjQ2ZmN6ak9jZTdQYVd1SG5rMFBFaE1FWDh4c0lDMENhWG5m?=
 =?utf-8?B?RjJwWlhJYlhjQ1pkNklrUmU3SWhjVU9rdWpOd2NYYkZiZDJ0Vk1TOG81YjdS?=
 =?utf-8?B?ZWpqenF6cnpESHMxTjVnK1BCQWRjcWJ4TEU3czlNNk5lOFBhWnowY3R3cHlt?=
 =?utf-8?B?MEZ4cGZXckE3ekV6bEw5WE1LZnpFUXNIQ3pjbm4wRjlhTWZZTnZINkd0MmVk?=
 =?utf-8?B?d0p2K3FzNFpiVHNuYzROR29CY2VFWko3WGIxcTM1dEZBNU8yZ0puNnB2UnpM?=
 =?utf-8?Q?jR8ajYPR7MonF?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 417876bf-8b30-482d-b1b2-08dad3d4a870
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2022 19:45:53.8363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mIqGGO/ksX36MrIM4G4btFUf9NV1XrMHoyukq94VZjjJoP9B5Qz0HRCzL2DumiHKX23YK3vGgiBr+e7xfSB+AKS+rpiKFXy7Q7Qm6FSbEOk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR03MB5162
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMDEvMTIvMjAyMiAxNjo1OCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToNCj4+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2FtZC5jIGIvYXJjaC94ODYva2VybmVsL2NwdS9h
bWQuYw0KPj4gaW5kZXggYzc1ZDc1YjlmMTFhLi5lYzdlZmNlZjRlMTQgMTAwNjQ0DQo+PiAtLS0g
YS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2FtZC5jDQo+PiArKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1
L2FtZC5jDQo+PiBAQCAtMTE1OCw2ICsxMTU4LDExIEBAIHN0YXRpYyBib29sIGNwdV9oYXNfYW1k
X2VycmF0dW0oc3RydWN0IGNwdWluZm9feDg2ICpjcHUsIGNvbnN0IGludCAqZXJyYXR1bSkNCj4+
ICAJcmV0dXJuIGZhbHNlOw0KPj4gIH0NCj4+ICANCj4+ICtERUZJTkVfUEVSX0NQVV9SRUFEX01P
U1RMWSh1bnNpZ25lZCBsb25nLCBkcjBfYWRkcl9tYXNrKTsNCj4+ICtERUZJTkVfUEVSX0NQVV9S
RUFEX01PU1RMWSh1bnNpZ25lZCBsb25nLCBkcjFfYWRkcl9tYXNrKTsNCj4+ICtERUZJTkVfUEVS
X0NQVV9SRUFEX01PU1RMWSh1bnNpZ25lZCBsb25nLCBkcjJfYWRkcl9tYXNrKTsNCj4+ICtERUZJ
TkVfUEVSX0NQVV9SRUFEX01PU1RMWSh1bnNpZ25lZCBsb25nLCBkcjNfYWRkcl9tYXNrKTsNCj4+
ICsNCj4+ICB2b2lkIHNldF9kcl9hZGRyX21hc2sodW5zaWduZWQgbG9uZyBtYXNrLCBpbnQgZHIp
DQo+PiAgew0KPj4gIAlpZiAoIWJvb3RfY3B1X2hhcyhYODZfRkVBVFVSRV9CUEVYVCkpDQo+PiBA
QCAtMTE2NiwxNyArMTE3MSw0NCBAQCB2b2lkIHNldF9kcl9hZGRyX21hc2sodW5zaWduZWQgbG9u
ZyBtYXNrLCBpbnQgZHIpDQo+PiAgCXN3aXRjaCAoZHIpIHsNCj4+ICAJY2FzZSAwOg0KPj4gIAkJ
d3Jtc3IoTVNSX0YxNkhfRFIwX0FERFJfTUFTSywgbWFzaywgMCk7DQo+IExPTCwgSSdkIGxvdmUg
dG8gaGVhciBob3cgTVNSX0YxNkhfRFIwX0FERFJfTUFTSyBlbmRlZCB1cCB3aXRoIGEgY29tcGxl
dGVseQ0KPiBkaWZmZXJlbnQgTVNSIGluZGV4Lg0KDQooVmVyeSkgYmFjayBpbiB0aGUgZGF5LCB0
aGlzIGlzIHdhcyBhIHNwZWNpYWwgZm9yICVkcjAgb25seS4NCg0KV2hlbiB0aGUgZmVhdHVyZSB3
YXMgbWFkZSBhcmNoaXRlY3R1cmFsIChDUFVJRC44MDAwMDAwMS5lY3hbMjZdICJkYXRhDQpicmVh
a3BvaW50IGV4dGVuc2lvbnMiKSwgMyBtb3JlIHJlZ2lzdGVyZWQgbmVlZGVkIHRvIGJlIGFsbG9j
YXRlZC7CoA0KDQpUaGVyZSdzIGFsc28gQ1BVSUQuODAwMDAwMDEuZWN4WzMwXSAiQWRkcmVzcyBN
YXNrIEV4dGVuc2lvbnMiIHdoaWNoIG1lYW4NCiJhbGwgMzIgYml0cyB3b3JrIiwgd2hlcmUgcHJl
dmlvdXNseSBvbmx5IGJpdHMgYWJvdmUgMTIgdG9vayBlZmZlY3QuwqANCkkuZS4geW91IGNhbiBu
b3cgbWF0Y2ggd2l0aGluIHRoZSBzYW1lIHBhZ2UuDQoNCkFuZCBzb21ld2hlcmUgSSdtIHByZXR0
eSBzdXJlIHRoZXJlJ3MgYW5vdGhlciBiaXQgKE5ldyBpbiBaZW4yL1JvbWUgPykNCnNheWluZyB0
aGF0IGFsbCA2NCBiaXRzIHdvcmssIGJ1dCBJIGNhbid0IGFjdHVhbGx5IGxvY2F0ZSB0aGUgQ1BV
SUQgYml0Lg0KDQp+QW5kcmV3DQo=
