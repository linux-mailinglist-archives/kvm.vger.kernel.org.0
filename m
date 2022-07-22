Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6B957E965
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 23:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236623AbiGVV7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 17:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbiGVV7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 17:59:11 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Jul 2022 14:59:09 PDT
Received: from esa4.hc3370-68.iphmx.com (esa4.hc3370-68.iphmx.com [216.71.155.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051C8218E
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 14:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1658527148;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FZflvlAiYHngmCzVj6z1L/rbWjCLvQ2jOBvcm4htaaE=;
  b=PlqOnnCQzSPN42+HrFGJOBT1LCJ0DtOj29N0C6YLdECj94eisk9D+fRJ
   vI6NhlbpsxVBz2QQ3J7dIj34F7SCvOla8e5ibKMqi75S4VS59CJX801PF
   gitd+DD2Eq7VL0Gwh1YmPP/OmCTsnpduvxzo6I5BCeZ2dN7xoJI4ePPlH
   I=;
X-IronPort-RemoteIP: 104.47.57.170
X-IronPort-MID: 79016450
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:12MDsq9ZwWWPs6+W4bp6DrUDT3+TJUtcMsCJ2f8bNWPcYEJGY0x3n
 GRNXzrVOP3cMDD3e4oib9+x8BhQvpGAx98wGwdrpC88E34SpcT7XtnIdU2Y0wF+jyHgoOCLy
 +1EN7Es+ehtFie0Si+Fa+Sn9z8kvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYctitWia++3k
 YqaT/b3ZRn0gFaYDkpOs/jZ8Ew15qyo0N8llgdWic5j7Qe2e0Y9VPrzFYnpR1PkT49dGPKNR
 uqr5NlVKUuAon/Bovv8+lrKWhViroz6ZGBiuVIPM0SWuTBQpzRa70oOHKF0hXG7Kdm+t4sZJ
 N1l7fRcQOqyV0HGsLx1vxJwS0mSMUDakVNuzLfWXcG7liX7n3XQL/pGLWgxG4422PhLLD9N5
 f8xLm8jdEq/iLfjqF67YrEEasULCuDOZdpallQ+iDbTALAhXIzJRLjM6ZlAxjAsi8tSHPHYI
 c0EdT5oaxeGaBpKUrsVIMtmwKH02T+iLHsB9wr9SakfugA/yCRY1rT3PcWTUduNXchPxW6Tp
 37c/nS/CRYfXDCa4WXUqivy2rKX9c/9cI8QK6+RqqFvuUaKmk8MAycqRUuUi9Ds3yZSXPoac
 ST44BEGr6076FCwSd/VUBq/r3qJ+BUbXrJ4EPM/wB+Cx7CS4AuDAGUACDlbZ7QOrMUxQy4r0
 F6hhd7lBTVz9raSTBq18raSsCP3OiUPK2IGTTELQBFD4NT5pow3yBXVQb5LCKypptLyHj70z
 naBqy1WulkIpcsC1qH+8VWZhTup/8HNVlRsuV2RWX+55ARkYoLjf5av9VXQ8fdHKsCeU0WFu
 38H3cOZ6YjiEK2wqcBEe81VdJnB2hpPGGe0bYJHd3X5ywmQxg==
IronPort-HdrOrdr: A9a23:xrWAkqu/DMb2xKdZv0pW4tKS7skC1YMji2hC6mlwRA09TyXGra
 2TdaUgvyMc1gx7ZJh5o6H6BEGBKUmslqKceeEqTPqftXrdyRGVxeZZnMffKlzbamfDH4tmuZ
 uIHJIOb+EYYWIasS++2njBLz9C+qjJzEnLv5a5854Fd2gDBM9dBkVCe3+m+yZNNWt77O8CZf
 6hD7181l+dkBosDviTNz0gZazuttfLnJXpbVotHBg88jSDijuu9frTDwWY9g12aUIP/Z4StU
 z+1yDp7KSqtP+2jjXG0XXI0phQkNz9jvNeGc23jNQPIDmEsHfpWG0hYczAgNkGmpDr1L8Yqq
 iJn/7mBbU115rlRBD2nfIq4Xin7N9h0Q669bbSuwqfnSWwfkNHNyMGv/MWTvKR0TtfgDk3up
 g7oF6xpt5ZCwjNkz/64MWNXxZ2llCsqX5niuILiWdDOLFuIYO5gLZvi3+9Kq1wah7S+cQiCq
 1jHcvc7PFZfReTaG3YpHBmxJipUm4oFhmLT0AesojNugIm10xR3g8d3ogSj30A/JUyR91N4P
 nFKL1hkPVLQtUNZaxwCe8dSY+8C3DLQxjLLGWOSG6XXJ0vKjbIsdr68b817OaldNgBy4Yzgo
 3IVBdCuWs7ayvVeLmzNV1wg2XwqUmGLETQI5tllulEU5XHNcnWGDzGTkwymM29pPhaCtHHWp
 +ISeBrP8M=
X-IronPort-AV: E=Sophos;i="5.93,186,1654574400"; 
   d="scan'208";a="79016450"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Jul 2022 17:58:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m+6VfupUxDcWryz/wQGJtvzO6pCoJVoXfwHVmcP/EVkmWw4u58GPeJZugr1JLehYvgWIIHKtj3TCdz6h+tEFv6UqxIcPOPdYgQxnvwMfQ01Soe8TGkHDcdCeknIPZbz/7r5aERS1Ua4oxaP88Ti8SEie3LmL2Gal6BKIca8Gl6EvMEgW/HiG5EL9pun1hFvB9PSgxF3WGfMDuoNa8FPsQuw90M8ErQQ+wUIbYy2sEcy8rCWdYfhH5MbY7NhpeC/Rey3hYj8dWpMVekPta1f8REOVFYdkKDOkrg64FF2I7Xpf2VceMRQFcHcQobOuvNByE767a6jCZBypyOQ1mslaeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FZflvlAiYHngmCzVj6z1L/rbWjCLvQ2jOBvcm4htaaE=;
 b=R3qvMhOwxDqz4OK/iWvSSS+71Zmp7hveVBWIYIqayxcCT0awCfxyFDftQkaYyxyCD6Z1svh1nr8h0k/t8AeqvfzrKfrZ+alraaBXcqmc12lh6GprRoWAhBB0EZvZYv/y6YPQNv2VenHj1qxoHATiqVW2z0aWh7dhKdJ43+Nd4hHkAb/FEJhJBOXhqPfWZubCKvx2+MiHKuTrR4OQE7+xAMg5HTakRqixHEUB+eDLgAbSO29BloK3bGp7hHhbB4NwKh97kw/CXCFzMeEZhN+ogSxFIxBoRCvAUZg1DNnF+NCl/50A6gK1jNUnPRrv/fHFxocQiwU7tDwtfzEeRForJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FZflvlAiYHngmCzVj6z1L/rbWjCLvQ2jOBvcm4htaaE=;
 b=ksyE5W9f5+CppxIZ9Y841jIIO6BcBNVNSN49Y/PJizBsEG15Y6iDOy6VFTOO8SMzax9BkYnAwoygEQM1i8wsGf5C76EeucrYPGYs+V8WdvJsiVTpXO5v2yk+phe0/NwcLma215QYK6WtSTSHc6LMGRKev0yaWfpE+mXXOdipfDM=
Received: from BYAPR03MB3623.namprd03.prod.outlook.com (2603:10b6:a02:aa::12)
 by BLAPR03MB5650.namprd03.prod.outlook.com (2603:10b6:208:29c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 21:58:01 +0000
Received: from BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::bd46:feab:b3:4a5c]) by BYAPR03MB3623.namprd03.prod.outlook.com
 ([fe80::bd46:feab:b3:4a5c%4]) with mapi id 15.20.5438.028; Fri, 22 Jul 2022
 21:58:01 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: RFC: The hypervisor's responsibility to stuff the RSB
Thread-Topic: RFC: The hypervisor's responsibility to stuff the RSB
Thread-Index: AQHYnhYc7CxvEz2GAUuQtkjJ1806mg==
Date:   Fri, 22 Jul 2022 21:58:00 +0000
Message-ID: <02ff6ca4-7878-e848-cb3d-af880b1bbb58@citrix.com>
References: <CALMp9eT4-hVw9Gwp00K59JstS52vidSRcV0WW5qEhJvaY6aR5g@mail.gmail.com>
In-Reply-To: <CALMp9eT4-hVw9Gwp00K59JstS52vidSRcV0WW5qEhJvaY6aR5g@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbbbd174-e793-44c0-3188-08da6c2d3ee9
x-ms-traffictypediagnostic: BLAPR03MB5650:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZGeyERsc0XH9phbu4yYJuQDRw2g2IbmM/1Ah19yAXDdkS56Tkl3N/6HHFv0RZgVMQVQLB+7sOupxYmIjGRyYP2e7iVCAs1aSYOhl7jWSKZGSrjXiI+PNBK0GjV+dsSUbYL5RtryIKnAimKy6pfD6/72GE9crN1VCuETiuZJrjTZSnnnGCHGJKtXBZIoVX8VeAOsLgQ7GYRYSx18okf9v8GkxP8G4OUr9mSJcO1A7czC9kXztqEmaVjqm/2oFKNXrLavjn61iE3omXMmBXllqPqwUeTLs4o/yP5j8+O7oVjeBCGpg72MAWC1sf0JS9/fyPo85GIvog7zAIEAlb5uVM14WKVR53rNhMDcHt20JfxziMfOt7L48v5433osVwPEZlkVjCuMAiEvsqkfIoiuHG8JVGL4S/7/03T5iMlZfQhnrynUkAY98CLa9zNc2T05vGOgGvmKibuBySZiMoNOQx08qsy74dTGXWx8m9UfLHSsErf9Q9ukbQ6iaUz34GVgZfZfE4+K5OHDMX76XzN0zY6t++IjspvnOyoSDExRoteYjfNKR2rM3LebrtQdVSRD3N6muoFwGlcQigEIQfCoCXlxXlzCkGao8KDXUKb2+Iwc2/ayI/8j+MdSQNRP3HRA5g/AmTvdsrqlVrtscoOy2+bT0dDxNJowTKxVk+ANNTTrVdioP0hCO1eQQI/c33370YNNOikjYSv9f98o/LgHmqY5De0KAkI7kR4xFoFeqTOGyqyrng2sX4x+17Vwy71K6iGxgaTnXDOuRuDGH0g+I9e3CJN6yVboz941qawgy6j729mM9gtUG8cmuV2amtzBovpDutaIr88ZVxwjpFFQjOFzx8b2CVywyViXPi4V0iPlG6arTSysyIvRVMY/w0vPh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3623.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(136003)(346002)(376002)(6486002)(316002)(66946007)(71200400001)(36756003)(4326008)(64756008)(66446008)(54906003)(66556008)(76116006)(110136005)(83380400001)(91956017)(2616005)(107886003)(186003)(8676002)(478600001)(26005)(53546011)(86362001)(66476007)(41300700001)(31696002)(31686004)(5660300002)(6512007)(2906002)(38070700005)(8936002)(6506007)(38100700002)(82960400001)(122000001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3liYUtrVlFBTlhucTh6cy9pNU4xWEJCMkozWUptZHJpcWxlaHE5OXZlUXdR?=
 =?utf-8?B?ZUVWTDNxai9OREZPb1ByV2NLdVVhMkhxQnZadUVLRzhCMnZsSGRERjk4T1Vx?=
 =?utf-8?B?VWhWRFpRaHo0d09GYnN6cDVHN2dVa3NtdWJoWVJZNnlxNzF2Q1phL3hGNTMz?=
 =?utf-8?B?aGxiTVlLbHFqUUJ0L1hEc3l2VE9RZ2xaL2loUDJaTXNieDVWSWg5aCtsOUtC?=
 =?utf-8?B?SUFwN05oLzZlTHhJV0x2SVRYNTEzTndJWENRV2lwSnFsVEpoRXVQVFRUbTFk?=
 =?utf-8?B?Uk01dU1YYlNvRXA5c0lmMWF2d2lBVHAwaEVhYVhqUFBERnNXMXlwUUxsWDNC?=
 =?utf-8?B?NDNtUHRRcXRGZkw4ZTkweXlIUy9xb0pya0RveUkxVUJsemthMTlNMUZ6QnY0?=
 =?utf-8?B?Y0VqZFB2NEpxelNoZEIvMENMYjNSdC80VXhMWnBLK08yZmZUU2IzVEhVVndr?=
 =?utf-8?B?Mm5TUjYwMktWcktzOForTEhJSnQ0Ty9sMnNtZ3FQdlFGMTY0NjZnQ2NVN2RB?=
 =?utf-8?B?amVqdWpkWUZ0RnRKWitxSmNLNTRPM2ZoNnVUSXdHZnhrOEhIRDJxRTFFRnlO?=
 =?utf-8?B?UHFTNStmUzJBSVU3RXl0MWdkeGZoWnBnWWZhTXVpQ094d1VTRFo4Q2o4WmtE?=
 =?utf-8?B?UEZFMDg3TDRBL1lCcngwVi81dXJxaFpvQzhuVjErTFh4Qkd0Z3pTTnhtMmZE?=
 =?utf-8?B?bDRzNkZxUkgvYWZzM0duUXJZTWVOd1lSR1ZqN0l4b0NYbG8rSUpaQWZQVXF5?=
 =?utf-8?B?WTFEVnRiWGUyaXU5bjEzT2NpRFpneUxtN2l5SHE0ckROMS9rb2RLRHY1TTJL?=
 =?utf-8?B?L2c1czUxeHhlMzU4RkRyS2xXcDh0R2wrMmdVdnIrU212cmRXWGlYb2h3VzZW?=
 =?utf-8?B?TlpxRytybHZEVjk2d0ZCQUJ2ODRhd0d6aHZkWlR1cThETGNuMFVONlYrc1VG?=
 =?utf-8?B?eXNyRlRwc0RhMFNDSUdnOXVBRDhueG8reXZOcFpwN0RaQ1hpRHB0b1VuNWFQ?=
 =?utf-8?B?UmFXUzBQQ0doL2krM1BJTEtiYU0vOFNnR2M2RTUrZG1kYXRZLytkMXBMRWky?=
 =?utf-8?B?cGMreUtNZEtnYXY3OFdjOEpYU3RaaEJYNmxVL0xhT0FPTzlmVXJJbzhrSjA1?=
 =?utf-8?B?QWxCdjFtWTVTbzdTMWVzdTJtdGtxYUxJM1ZDWEhLNGZEWWp5MG1laXN3OWRS?=
 =?utf-8?B?QW1XRTFSbXNKNVpZY1ArK0F3QzgxR0hyV0N1c1RjQ0NqM1RpVU9QNGxLVVdR?=
 =?utf-8?B?aUNoQ0h5NjE2RlFwUmpLTkUrM2FTZ3BGTjVQbjBVU0JZUSsySjB5bmtheGxX?=
 =?utf-8?B?VE14MkNkOGdMSSt1d2tjREw1ekFFczRiQ000N3p1QndoQXhaQmxwMU1pSDNt?=
 =?utf-8?B?V25QbVFOTUU3STJ3ekVOV3V4YnRJQXlsVmhURVhxK0Z6OCtHV3ByRGZMSUZO?=
 =?utf-8?B?Ykk1UXNGMzZhYmZwUWt3L1g0UU1iYVNWRmtRWjcvVTJnS3JORmxLTmxzbjhO?=
 =?utf-8?B?aEUvN3lhV3U5TlpvaFVEQ2hGTUFwaHBEaGpvL1JMWmdlSkdDbnRlTlluMjIw?=
 =?utf-8?B?NE9ObFFHNGNuYlRVcnFZUEVPSWN3ZVZmdm50NFByMWpZc2YvYWo3czF6Vyt6?=
 =?utf-8?B?WGQyOWRCRXJUL0FuNTI0SlBKeEQ4RVEzRkRZRUozWWs4MTNXWFpoUks2Q3pJ?=
 =?utf-8?B?c1V2RVl4SW1qcDFSdTJTUUl4ekJRbUN6NzFHQW4yeGtnazFIRE80UEtFUThG?=
 =?utf-8?B?ZkdFMEpwOEFDOTd0UmdDRXNOVDVCbmNJNy92YlVJckx3Z0xIS0lLcitTM1Rq?=
 =?utf-8?B?ZThsOUY3ek0xNitCVUxYQU5BRm9aUlQzTHVHZExhTXFFU1hsYW1qYWpDdmZC?=
 =?utf-8?B?Q3EyOFN6QkdRdWdaZS9HT0RrYlZlTFZUNUIwN2swaFptNDVWY29zQzU1QWd0?=
 =?utf-8?B?bENJSTZzZWNRUzVGSDR3bDg4NlZGS2RhQzhEY2lMR2lzWVFSZENxUVE0WExC?=
 =?utf-8?B?ZUFydFVRZkdHbEt0RENCUVUweUZqUlVheTQwaUxONGFwVFJuOFVzYWk1cENG?=
 =?utf-8?B?dm9NeFVIZUJwaHp5R1Vsem0xd3dyNFRyL1hOd1psSW12WmhSc29DbHJ3Q056?=
 =?utf-8?Q?Yt5Gh5VFmME1gy8j7QZ7WjAE4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF9BB0777BBEBC43BE910221AB889866@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3623.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbbbd174-e793-44c0-3188-08da6c2d3ee9
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 21:58:01.0519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 33YUFQ5tUFLipgtZqUzSMz3iGUkrf18/dF7coJqtVjM3Vca7+TieHxH6o071TtgD+WLRf8Plw3hqvGNfd+X0vcqLfB1ICYmEneHi3RremE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR03MB5650
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gMjIvMDcvMjAyMiAyMjozNSwgSmltIE1hdHRzb24gd3JvdGU6DQo+IE5vdyB0aGF0IFJldGJs
ZWVkIGhhcyBkcmF3biBldmVyeW9uZSdzIGF0dGVudGlvbiBiYWNrIHRvIFNreWxha2Uncw0KPiBS
U0JBIGJlaGF2aW9yLCBJJ3ZlIGJlZW4gaGVhcmluZyBtdXJtdXJpbmdzIGFib3V0IHRoZSBoeXBl
cnZpc29yJ3MNCj4gcmVzcG9uc2liaWxpdHkgdG8gc3R1ZmYgdGhlIFJTQiBvbiBWTS1lbnRyeSB3
aGVuIHJ1bm5pbmcgb24gUlNCQQ0KPiBwYXJ0cy4NCj4NCj4gUmVmZXJyaW5nIGJhY2sgdG8gSW50
ZWwncyBwYXBlciwgIlJldHBvbGluZTogQSBCcmFuY2ggVGFyZ2V0IEluamVjdGlvbg0KPiBNaXRp
Z2F0aW9uLCIgaXQgZG9lcyBzYXk6DQo+DQo+PiBUaGVyZSBhcmUgYWxzbyBhIG51bWJlciBvZiBl
dmVudHMgdGhhdCBoYXBwZW4gYXN5bmNocm9ub3VzbHkgZnJvbSBub3JtYWwgcHJvZ3JhbSBleGVj
dXRpb24gdGhhdCBjYW4gcmVzdWx0IGluIGFuIGVtcHR5IFJTQi4gU29mdHdhcmUgbWF5IHVzZSDi
gJxSU0Igc3R1ZmZpbmfigJ0gc2VxdWVuY2VzIHdoZW5ldmVyIHRoZXNlIGFzeW5jaHJvbm91cyBl
dmVudHMgb2NjdXI6DQo+Pg0KPj4gMS4gSW50ZXJydXB0cy9OTUlzL3RyYXBzL2Fib3J0cy9leGNl
cHRpb25zIHdoaWNoIGluY3JlYXNlIGNhbGwgZGVwdGguDQo+PiAyLiBTeXN0ZW0gTWFuYWdlbWVu
dCBJbnRlcnJ1cHRzIChTTUkpIChzZWUgQklPUy9GaXJtd2FyZSBJbnRlcmFjdGlvbnMpLg0KPj4g
My4gSG9zdCBWTUVYSVQvVk1SRVNVTUUvVk1FTlRFUi4NCj4+IDQuIE1pY3JvY29kZSB1cGRhdGUg
bG9hZCAoV1JNU1IgMHg3OSkgb24gYW5vdGhlciBsb2dpY2FsIHByb2Nlc3NvciBvZiB0aGUgc2Ft
ZSBjb3JlLg0KPj4NCj4+IFNvZnR3YXJlIG1heSBhdm9pZCBSU0IgdW5kZXJmbG93IGJ5IGluc2Vy
dGluZyBhbiDigJxSU0Igc3R1ZmZpbmfigJ0gc2VxdWVuY2UgZm9sbG93aW5nIGFsbCBvZiB0aGUg
YWJvdmUgY29uZGl0aW9ucy4NCj4gS1ZNICpkb2VzKiBzdHVmZiB0aGUgUlNCIG9uIFZNLWV4aXQs
IHRvIHByb3RlY3QgdGhlIGhvc3Qga2VybmVsLg0KPiBIb3dldmVyLCBpdCBmYWlscyB0byBzdHVm
ZiB0aGUgUlNCIG9uIFZNLWVudHJ5LiBTdHVmZmluZyB0aGUgUlNCIG9uDQo+IFZNLWVudHJ5IGlz
IG5lY2Vzc2FyeSB0byBwcm90ZWN0IHRoZSBndWVzdCBpZiBLVk0gaGFzIG1hZGUgYW55IHVuc2Fm
ZQ0KPiBjaGFuZ2VzIHRvIHRoZSBSU0IsIHN1Y2ggYXMgcmVkdWNpbmcgaXRzIGRlcHRoLiBUaG91
Z2ggSW50ZWwgZG9lc24ndA0KPiBzcGVsbCBpdCBvdXQsIHRoZSByZXNwb25zaWJpbGl0eSBvZiB0
aGUgaHlwZXJ2aXNvciBvbiBWTS1lbnRyeSBpcyBtdWNoDQo+IHRoZSBzYW1lIGFzIHRoZSByZXNw
b25zaWJpbGl0eSBvZiB0aGUgU01JIGhhbmRsZXIgb24gUlNNLg0KPg0KPiBGb3IgcmVmZXJlbmNl
LCBoZXJlJ3MgdGhlICJCSU9TL0Zpcm13YXJlIEludGVyYWN0aW9ucyIgc2VjdGlvbiBvZiB0aGUN
Cj4gYWZvcmVtZW50aW9uZWQgcGFwZXIsIHJlZmVyZW5jZWQgYWJvdmU6DQo+DQo+PiBTeXN0ZW0g
TWFuYWdlbWVudCBJbnRlcnJ1cHQgKFNNSSkgaGFuZGxlcnMgY2FuIGxlYXZlIHRoZSBSU0IgaW4g
YSBzdGF0ZSB0aGF0IE9TIGNvZGUgZG9lcyBub3QgZXhwZWN0LiBJbiBvcmRlciB0byBhdm9pZCBS
U0IgdW5kZXJmbG93IG9uIHJldHVybiBmcm9tIFNNSSwgYW4gU01JIGhhbmRsZXIgbWF5IGltcGxl
bWVudCBSU0Igc3R1ZmZpbmcgKGZvciBwYXJ0cyBpZGVudGlmaWVkIGluIFRhYmxlIDUpIGJlZm9y
ZSByZXR1cm5pbmcgZnJvbSBTeXN0ZW0gTWFuYWdlbWVudCBNb2RlIChTTU0pLiBVcGRhdGVkIFNN
SSBoYW5kbGVycyBhcmUgcHJvdmlkZWQgdmlhIHN5c3RlbSBCSU9TIHVwZGF0ZXMuDQo+IEkgZG9u
J3QgcmVhbGx5IHdhbnQgdG8gZG8gdGhpcywgYnV0IEkgZG9uJ3Qgd2FudCB0byBiZSBuZWdsaWdl
bnQsIGVpdGhlci4NCj4NCj4gVGhvdWdodHM/DQoNClRoZSBzdWdnZXN0aW9uIGlzIHVucmVhbGlz
dGljLg0KDQpFdmVuIGlmIHRoZSBTTU0gaGFuZGxlciBkb2VzIHN0dWZmIHRoZSBSU0IsIGl0J3Mg
c3RpbGwgaW4gYSBzdGF0ZSB0aGUgT1MNCmNvZGUgZG9lcyBub3QgZXhwZWN0LsKgIChBbmQgaWYg
eW91ciBDUFUgbGFja3MgU01FUCwgeW91J3ZlIHRvdGFsbHkgbG9zdC4pDQoNClJldHBvbGluZSAq
aXMgbm90IHNhZmUqIG9uIFNreWxha2UtZXJhIENQVXMsIGFuZCB3ZSBrbmV3IHRoaXMgYmVmb3Jl
IHRoZQ0KU3BlY3RyZS9NZWx0ZG93biBlbWJhcmdvIGJyb2tlIGluIEphbiAnMTguwqAgSGF2aW5n
IFNNTS9WTU0gc3R1ZmZpbmcgb24NCmV4aXQgZG9lc24ndCBmaXggdGhlIHByb2JsZW07IGl0IGp1
c3QgcGFwZXJzIG92ZXIgdHdvIG9mIHRoZSBtYW55IGhvbGVzLg0KDQpYZW4gYWxzbyBkb2VzIG5v
dCBzdHVmZiBvbiB0aGUgZXhpdC10by1ndWVzdCBwYXRoLCBhbmQgSSBkb24ndCBjb25zaWRlcg0K
Y2hhbmdpbmcgdGhpcyB0byBiZSBhIHVzZWZ1bCBpbXByb3ZlbWVudCBpbiBzZWN1cml0eS4NCg0K
fkFuZHJldw0K
