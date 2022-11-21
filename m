Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E57B632E88
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiKUVNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKUVNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:13:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A739412D3C
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 13:13:04 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALKv0es016887;
        Mon, 21 Nov 2022 21:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=I4vg9njyPI9gWb5qRUNoqJuGvBE80+t/jFDF9hQeSzU=;
 b=qfaem/mGhA42V08E6TPhpxvVysBDomz5uNoorv0nAiPyR1hKT+LbmJPSzFdTCnDOWdh/
 w/pzNd4Qa/0AfmVgzGPJ4KqnnfxqtXYJarLBngJjqvWUT9UQj5Cr0aMZILlXPWRjdl06
 U+UpHQrggcRtiK0B+xuwVINfTe1m0KNddXokl+eXZ6z2Ac5uqs/GD8e/y9Fg8S0I6o1N
 G2+RY92yOCXaWM6ASMzBCzKfnvf3WpIfbowJY3b6FAsZd8HMetj3RCSummiLY1akcjIE
 HkfemE4RTpzh9adh5XMabDY1+/s/JBH2uDYK7HscETyKreP97FU9dHipF0KwYzmK/DG5 nA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m0afr1hqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:11:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ALKTEww002287;
        Mon, 21 Nov 2022 21:11:35 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkb3sxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:11:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JgYct2sp7fFeLyjTLNsat75p4kv6dXkKgX5oaic3WGjNzZZ4gAltFO/fYCqbQ7F9OKZdXhOqH8wlLVvm9TZn9J2YpVwM0J+jRL39xR5OBtjSOHKGryQjY3En+PmqL8+b6CfOwkh40ozeAKhxZqN2ZTyRxr+8lWjKQ0NAn5tES49EGcwS1Tq2XWRvBRSd0tr21goQX0rXANHMjtrhcYWpxetRSA8/LaavQxzVQSqlP6InrfahshOGyft/nFsZKIvFwf0TZ8mHDzXPnOUv4vWZ8oEv6iCpRFjbWP4rOOF0vMS2On6fM22lIVlfOGFbKlifeoh8RINJQuE5WLHbRsmsQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4vg9njyPI9gWb5qRUNoqJuGvBE80+t/jFDF9hQeSzU=;
 b=UoycQeSGZ9XPEbMSDgvhJvJpKDfIFMpN1KxlXGOfKDan0nebU7F0+g6cl63oMgR/O8iX2RKxQIplzlG7eOXnVw0rNm8xNwbIDpAAvRQYXch2qN0sNFHubztrH0qZJWquSrGrmLMtNUx5wwNhVYK48srgvXL/9PkGUlItrd2N76qk2FuQxjWPxmE+aPkeapBNFEqS5lQte3sSnwXu5gr57e4tdv7tqEK8p+6tOSTCArr8OxSiPz7UedtqS4C4aohHZUEJPB1QeQyn0UL3C11DizCfKAB9TW28jyXVzmm6JL0K9g6gTlKvtXK440cM0XJ1ToL3qW8O48W2+ndbZ8903A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4vg9njyPI9gWb5qRUNoqJuGvBE80+t/jFDF9hQeSzU=;
 b=KACbHglgIXuAOKO0JHj684I0vFWDYx9/vDV8LEh1BwVUluf9pIfg07jPwJhk/J4ec/+XeiefLlCnlRdRIltsNXuJfvs3YoyKAcHisoC4RYg1sFwtEzZ0Kwpm59YiC2m2e6tm23WsMZEZCFknvzRD3qShK7j/2vW6al3EIa7psSw=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CO6PR10MB5570.namprd10.prod.outlook.com (2603:10b6:303:145::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 21:11:32 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d%4]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 21:11:32 +0000
Message-ID: <8bafa723-eff0-a1f9-685d-75d0d5184309@oracle.com>
Date:   Mon, 21 Nov 2022 13:11:26 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 2/3] i386: kvm: disable KVM_CAP_PMU_CAPABILITY if "pmu" is
 disabled
Content-Language: en-US
To:     Liang Yan <lyan@digitalocean.com>, Greg Kurz <groug@kaod.org>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        pbonzini@redhat.com, peter.maydell@linaro.org, mtosatti@redhat.com,
        chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
        jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com,
        danielhb413@gmail.com, clg@kaod.org, david@gibson.dropbear.id.au,
        palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        joe.jin@oracle.com, likexu@tencent.com
References: <20221119122901.2469-1-dongli.zhang@oracle.com>
 <20221119122901.2469-3-dongli.zhang@oracle.com>
 <20221121120311.2731a912@bahia>
 <98067697-4205-4061-1cbb-a666f7021692@digitalocean.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <98067697-4205-4061-1cbb-a666f7021692@digitalocean.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::26) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CO6PR10MB5570:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ad325f5-2732-47dd-5ddf-08dacc04f70a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gi1zmpdo14aT0f7d/Oc1fE0j+lwJ+QwQcsFhmnaKmKZN2G9kXx87AYf8q/Ikh9cjH2x/Bfu1TxVeOsfgnChIFPx+tjPDcRkUc78qbkFmXkdmuFVyGDE8IrH2MoALlHO+S+EHWpS/hwoIMDDCseqN2+m4Qbu24qtelbXpMr/pZn1/8tME6ST0zf7RKpw12/niqTk4pqa0pOvd7vD+CeH+MHdX6VZ5EUL7qQgtHF9WaQsALfhpJ0mrPjGjZvpJ9opOL1ZntFz7YdrTChx9fpUnX/adOn11jfl8S8k6M2YnWdn+pghNVKrC+1UURV7NAK7ao8kzn0bIXnozeX+pxi4jFKhX/RNipvJFPNSKvMg7vWhS22lUMAJBtwxYrhtxDZZtnmWktjIJt6rWvb1NXUfyIzFm7czgV4Fwwrex3wBg2L3obF195SR+ULiR8huZokxj2x9D6Dv79pnS9IdqU1AJLIe3ICA+Gu59uup3gMQSpIf56e5YIVbpe/gao6L/1O9CRrIhxDDWFhw7vjlhthwHyEaY0yXWPRWmA2dFRzv3vBYE1AGOqaqXVlHAqeqOfDdX7UEJC193Oanryveeo1NhlXtoq9mCrghiq9hDD9aBBlyk+iXhDQ+XB7/5/3zZNnvf+RmVyrgIdKp9Gd9W22LjAO9K3oYEEbQoWx7xUkWM69DCIavR7MnbWtE3ecQHzlvOtxk2h2BjfghZcWq8pNbQrpF3p9HVBX9lIrKgX8PXALE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(38100700002)(31696002)(86362001)(6506007)(83380400001)(478600001)(53546011)(6666004)(7416002)(6486002)(8936002)(316002)(8676002)(4326008)(66946007)(66476007)(5660300002)(41300700001)(66556008)(186003)(2906002)(110136005)(2616005)(6512007)(44832011)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2lFTmdFU3FqVEo2eEc0c0tXd1E1bzNnMW0vQU5ZTUdPTCtScHFNV0ZFV242?=
 =?utf-8?B?NHZLRlhISklsNGxzdk5vdDgwRC9CWnhNMEFNSG00MVdWVXJoMWRNcTZRdDBE?=
 =?utf-8?B?RTFIZ1IvdVhJUG5KaHB3L0ZPNmh4ZFcxWDBlbXdsa1ZFeFNGQmFLcUpIM0xx?=
 =?utf-8?B?aFdwY1ppUWM5WkJHNmlua2tyTUZZZ3FiSnhIQkZzbkVxVlNhTnlaaHoyaUpZ?=
 =?utf-8?B?NEFwRlV2YUlMNXlTWTROZTB1S1krNk9oNnpDK3dPVjhUbnFWR1BPZzJpZXlQ?=
 =?utf-8?B?eFFOaXB6MlEyby96Vm0xM1lUQ0lTQ1kxZzMzK3p4WTNidmVWc0NObTBQWk5F?=
 =?utf-8?B?akIvYzRHcWZxWG1keExNSCtUR3pnTlRqTnhQVUNURmhOK0w1NWlHRVRCd09I?=
 =?utf-8?B?bmFNWDM2VmtMUHpmUWxyUVV4TE8wY2ZDVFdnVTMvbFlOS0lHakNnWE1YM3dW?=
 =?utf-8?B?RHNSOC9XY3lOYWNHWDRtdVhJNzNHN1doRXZCZnN6UGFMemc3alVDOHhsWnpN?=
 =?utf-8?B?dTZsbElJUXNkMzN1eDVnZWFTM0RTR1VHdGxrSTRYczNWaERQSVdvZUxIYlRr?=
 =?utf-8?B?eU1DUjZQMlFvTjk0cTdRdHh0ZDJjVC9XdFVCZGgvNlcwNUo2eDg3dE9ER1Nk?=
 =?utf-8?B?eG5idjA1Ym4xVVpZMERseGR4ZG01Wm5nY2ZmSnNSc1g0U0ZXcVBhRktYdlY4?=
 =?utf-8?B?NEdKdVI5aWFLVHVISno0b1MvNXBsQ2NCeUJ0MFNSRnRrTVVCSWRtWGYzNklN?=
 =?utf-8?B?emlxc2c5L0FOYWxibEp2TWpxNXcrNmJGK3B1OHREUnpFNWJaWFp2S05kZUtm?=
 =?utf-8?B?aXRweTZIWkdIcllMYnFFSnJnMVFmS0t0R3BxZ1JNM3kvbE9RMXdSR2lXcHRv?=
 =?utf-8?B?M2hsRDVmWjFicTdoclM4U0VSWUNqaGp1czgzbHVFSEZqRHBnVlZiUU02TlZw?=
 =?utf-8?B?NEhQTnNZT09wdUhmQWQ1WG9uVkNkVGYvbDZ6T0dvdmFzYUFvaE52WjMvZWJV?=
 =?utf-8?B?VHl2dGZVeWpiMEZYMEFZcFA2ZGNPUjFxV3FqWmFsdmdBaGd2S21CUURkZVRi?=
 =?utf-8?B?OEFBb21ZWTAwd2RTTGZwa3RJT0s2TEZJN1BBL1NBWVlWSjdpL1RHRXpiV085?=
 =?utf-8?B?UEhsN0VERWFTd2lwZVBCZnByVldud0FPc2ZxVDVVUWdvWE53V3NneG96Slkr?=
 =?utf-8?B?SUJHTFlFejk0T2NQZkwyZzNWKytTaHEvQTg1VWxWdFFiTXVVcWZJcEtQTUlG?=
 =?utf-8?B?N0JIWm9vbDhsdnd3WHMzcGMrZHF2L244MGIrZDlJU1g4VFViWTVDQ3hEeVV4?=
 =?utf-8?B?bEdBQlNvZGlLZU1ocVFuYzdiU2pVWUxTZUNmODdwZTN6Q0Y4Rk8zL3dXdnVI?=
 =?utf-8?B?bk1RMkgzWTIxeHd6bStMcys0RWVWclp4VVd5SGZBM1VCTk5oSUpRNzZjWHZn?=
 =?utf-8?B?VDAvbndVSjNaeUU5bEQ5ZnJ3QTBSZG9sOUlkUk5wdGUvZ0NhRXBDMWhTcXFx?=
 =?utf-8?B?L09SSDRkYWVEaUp0bDRzZFptUGViRGs0SWQ1R0FyTVBRRmZaVTIrTHVSTlRY?=
 =?utf-8?B?U01MMFhpdTYxTmZ5WjZPd2tSYzBkRWo3OGVsYzd5QmJ1ZklRSXgxZUdXRGJx?=
 =?utf-8?B?eS9xelc3RktyUGxMZk80L2hPMkNRVnpWbGlDdG9wcFFmN1IvODNNMGhEbzVq?=
 =?utf-8?B?VkVuTzdRekVJRnA1MFBEZzFwcXdlMjhJV0t4ZnFTcURtZjU4UG9oVHFiQWxs?=
 =?utf-8?B?MUVNQmNIMzZTcTFuYkEwWWFxclFQL0l5aC9URTFSYXZadGlySjFrWUowRmZK?=
 =?utf-8?B?anhEaHFpdkJrUTBONldRYWNTZlJneDM1ZlRmS0tZdzVHYi9kN2hGSTEvYlVI?=
 =?utf-8?B?NmhCWUZoekVXR1M5bzhhUGloR3VrY0JiMWFYMkxaVm9GaGpWZ1hkRElvc1lw?=
 =?utf-8?B?U0tFcFJSTkF1TitLaDJvZ2N2YkJURWR0N2pHV0Z0bzFRcFc1Z0RFWDYyeS9x?=
 =?utf-8?B?SmJpUy9tcVA0WW4wblloblBnNXVRNjludmh1YXlVaVBMR0cvb0oxVTVtNVhZ?=
 =?utf-8?B?WCthaHh5L0RNR1psamFTSlc2ME9pbnFjMi91ay9zU3ZXOWVkcVRsVTd0QjBH?=
 =?utf-8?B?dkcxc3FydE1adXozamRka0YwKzg3T2s0aFFsNnBzMUt2QkJwTC9oVXNZRS9k?=
 =?utf-8?Q?d251X3b2t+OKJx/0I0fGCIk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TGVubGZhK2gxSVQxNGlyYXUxMzVhNEFjN0h1ZzdQZkZWTHZNQm0vRmdZS3B4?=
 =?utf-8?B?dWdIREdiOFhrSzZlRnd0bHZOYnhhNDJKay9oem4ybzRLcWhrMG93VUJjWmp5?=
 =?utf-8?B?dnphbGVGajdtU29maWRsdTdBN2t1alpyZDh4Zml4TC9hU00ySzBwQ0o1Y2kw?=
 =?utf-8?B?SVhsN2Y3QU9jV00xSUFvN0tCNWZZamJoREs4eUZpdExYZGoxejBHSk44dWV2?=
 =?utf-8?B?Mkd2Y2Z3Y1EwOFJOWnAwdzZPeWtXRmtyT1ZVTkhuOGJSK2JucW1mZnhraTd1?=
 =?utf-8?B?YjkzN0g5bDE2SVFGNlV5bVUvT3BNQ2pOTHlsOHJtQUFZdDRhUmZ5T0Y3Q3RO?=
 =?utf-8?B?eG9KQnUxT1lPeE1jcWZta2VxWWU0MUJBaXo3V1ZSTEdYZUZFVDJVUVQyVWdu?=
 =?utf-8?B?VHozenlKakkvKzhPZXJGS0tBR1Y3OVIrdnJDYXVQQjU0UWp0bTNnQTBaTTFv?=
 =?utf-8?B?dVBMTUVlN1lUL2g3MTErend6YTYzSkJzcmhpcmFBYjl1Y1lUT1Iwb0ZLQm5C?=
 =?utf-8?B?dHhtR1FEbGpVWUVsTWVvZzJzV2trQnJHMjJCL2tYWEZtODVJRFlZcXZzTk9L?=
 =?utf-8?B?cXNmUmhyMlh3M1BPemcvaDZ0WC9UMUF2aXQ1cGpCL0phc1VmdVJpM0gvZTZi?=
 =?utf-8?B?cUIzdUJaQmxhVU1rNVRaL3VjRHdKcGxLdTNOQkZBMnJTWjJsbTU4d0lFS2Fq?=
 =?utf-8?B?MURWM3RndjBLSmpxOUVqN1pBcm1mSENXUjc4emxLTjRlQ3ZNNWF2QVBaSGth?=
 =?utf-8?B?eUZLUDdTTXpoN0VLanAwWVFuTVNqWjg3SUJoRHBOR3NZY0ZucS9PVzlYMFRw?=
 =?utf-8?B?QkIybGorc09zRTVlYi9tcm9aa2ZmKzY2OUduV1NwTUEwUHY3cktDOGxlcnYr?=
 =?utf-8?B?V2tOYm1kNHhBdVYyVlk1NGJzdFFzWEFFVFZqMUR2ejUwcDJLNkN3OTBZSUJG?=
 =?utf-8?B?YWtwR3ZRVjFkYUE4bElJWXRHSDhycS9vTXVpUE9yTkxyU3cxWFNvdG5MWks2?=
 =?utf-8?B?OTZkbWxBVm4xdkdyQ2hQZkY1TjllbndLWWlDclp2QzhJVE9VbFpVZ2s4bm1q?=
 =?utf-8?B?bnlZM0VUTUxaNXBWbkR6c3g4TlB0N01uZUNsdTlGdXZzSytPeEF4NnhqVkhF?=
 =?utf-8?B?MTNIWEh1QjV0ZitnMG1VZHFoYW9DSU1keU1JL3c1WXRxcUxPSUNyZmh1bWxN?=
 =?utf-8?B?VzdEYWw3NU1mRTl6QkhwWlp1VUtnNFp1c01CcXEwQ0NFNXpwK0EvQ1BrOG01?=
 =?utf-8?B?ZG84Mm1lWG9YMmV0VVI1OTVraDYvNzZBODhyWnM3N2R3OUpzOWZWVzdMWU5D?=
 =?utf-8?B?bjY5TStlUTVXeUdJdHk2WmY3MWZMZ2lTYkxWcWNySlU5ZmtrT2FpM3IzQzU2?=
 =?utf-8?B?YkxsendrWEI1dUQvQTJ1djNHblBKRjV0Qi82YnEvTFhBNlBMM3RmZWQxREtJ?=
 =?utf-8?B?QUhoVTErSXpKamVNL1IrRUxkaGhObFlpQjRPaUhqeSt6N0ZXT0E2ZFRWcm1V?=
 =?utf-8?B?TEhraHhLcHJ3RmlvbWxBSjZ3dVlEdGxpakNLL0QyN3dhTnhGaDJPalc3MHVm?=
 =?utf-8?B?OXFoc0M2YWRMQUNQTllxYmE0S1RHVFlLWXlvdW5YUXJPWE14MkRZWnZ2eU1D?=
 =?utf-8?B?Qk9DL0pmanluY2dMR2MzK0Q4QUgyUDRNNDczQ2JNc3E3NWwxblk0TkZQcnMv?=
 =?utf-8?B?VzRlTWJrN2NsaEhyT1E2bDZ0TzMwR3pWMkVxVVZwd0pseVlwSWJFRUlWZ0dt?=
 =?utf-8?B?ZzZjVkVMNlh6NS9VY214MzJ1Yk9jR0VQR2syOStUWkt6OThrM2JSYnFxbjVr?=
 =?utf-8?B?NjNJR0oyaUNtYnBQZGtaRndLVlBxdktCbEFjeUlQUXBWUndkSE85NXlodTh0?=
 =?utf-8?B?R1pacGsyTFR5dWJSbGZOSDBrekw0WnVQOTFmT2drZnY3bURVSUJBeEFNTy9G?=
 =?utf-8?B?M0FwdThkY3ozaW51QVFUaXBPTldSK3UxMzFvbHJla3NRYjdWbkNDb0NxRkV1?=
 =?utf-8?B?a3dFSkgya3dzaE9wU3dYYUhHSTliWW8xOE9EQ2JIL1BjYzJXNFRoRElvTVps?=
 =?utf-8?B?VHpwRDlWYU9JdHl4aXdBdFpOek4wMHUySkl1cEV1SVNZbjh0KzcyakR2QXdG?=
 =?utf-8?B?SmdqNEpHbGkvZjhvTDZPcW84U1V0cFg4ZUdULzNpbmllTVlRRUdFRE0zeVpB?=
 =?utf-8?Q?ZVH89oyvwL54F1E25EAOSws1K1auyp/B/k9hlptTOl1u?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad325f5-2732-47dd-5ddf-08dacc04f70a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 21:11:32.4652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tILrzFEZdJ7Q020OWOjqGsLcoLjUu0PCthEkZ3XysGwGrIDXuhUCpWH0nxEqhiRyD4T6jmurfqPTdjoD8fR2yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5570
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_17,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210159
X-Proofpoint-GUID: WqBd4qQhOfhGkjeGdYj81ytFX22R4iEw
X-Proofpoint-ORIG-GUID: WqBd4qQhOfhGkjeGdYj81ytFX22R4iEw
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Greg and Liang,

On 11/21/22 6:23 AM, Liang Yan wrote:
> 
> On 11/21/22 06:03, Greg Kurz wrote:
>> On Sat, 19 Nov 2022 04:29:00 -0800
>> Dongli Zhang <dongli.zhang@oracle.com> wrote:
>>
>>> The "perf stat" at the VM side still works even we set "-cpu host,-pmu" in
>>> the QEMU command line. That is, neither "-cpu host,-pmu" nor "-cpu EPYC"
>>> could disable the pmu virtualization in an AMD environment.
>>>
>>> We still see below at VM kernel side ...
>>>
>>> [    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.
>>>
>>> ... although we expect something like below.
>>>
>>> [    0.596381] Performance Events: PMU not available due to virtualization,
>>> using software events only.
>>> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
>>>
>>> This is because the AMD pmu (v1) does not rely on cpuid to decide if the
>>> pmu virtualization is supported.
>>>
>>> We disable KVM_CAP_PMU_CAPABILITY if the 'pmu' is disabled in the vcpu
>>> properties.
>>>
>>> Cc: Joe Jin <joe.jin@oracle.com>
>>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>>> ---
>>>   target/i386/kvm/kvm.c | 17 +++++++++++++++++
>>>   1 file changed, 17 insertions(+)
>>>
>>> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
>>> index 8fec0bc5b5..0b1226ff7f 100644
>>> --- a/target/i386/kvm/kvm.c
>>> +++ b/target/i386/kvm/kvm.c
>>> @@ -137,6 +137,8 @@ static int has_triple_fault_event;
>>>     static bool has_msr_mcg_ext_ctl;
>>>   +static int has_pmu_cap;
>>> +
>>>   static struct kvm_cpuid2 *cpuid_cache;
>>>   static struct kvm_cpuid2 *hv_cpuid_cache;
>>>   static struct kvm_msr_list *kvm_feature_msrs;
>>> @@ -1725,6 +1727,19 @@ static void kvm_init_nested_state(CPUX86State *env)
>>>     void kvm_arch_pre_create_vcpu(CPUState *cs)
>>>   {
>>> +    X86CPU *cpu = X86_CPU(cs);
>>> +    int ret;
>>> +
>>> +    if (has_pmu_cap && !cpu->enable_pmu) {
>>> +        ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
>>> +                                KVM_PMU_CAP_DISABLE);
>> It doesn't seem conceptually correct to configure VM level stuff out of
>> a vCPU property, which could theoretically be different for each vCPU,
>> even if this isn't the case with the current code base.
>>
>> Maybe consider controlling PMU with a machine property and this
>> could be done in kvm_arch_init() like other VM level stuff ?
>>
> 
> There is already a 'pmu' property for x86_cpu with variable 'enable_pmu' as we
> see the above code. It is mainly used by Intel CPU and set to off by default
> since qemu 1.5.
> 
> And, this property is spread to AMD CPU too.
> 
> I think you may need setup a machine property to disable it from current machine
> model. Otherwise, it will break the Live Migration scenario.

Initially, I was thinking about to replace the CPU level property 'pmu' to a VM
level property but with a concern that reviewers/maintainers might not be happy
with it. That may break the way other Apps use the QEMU.

I will add an extra VM level property to the kvm_accel_class_init() for
"-machine accel=kvm" in addition to the existing per CPU property. The VM (kvm)
level
'pmu' will be more privileged than the CPU level 'pmu'.

Thank you very much!

Dongli Zhang

> 
> 
>>> +        if (ret < 0) {
>>> +            error_report("kvm: Failed to disable pmu cap: %s",
>>> +                         strerror(-ret));
>>> +        }
>>> +
>>> +        has_pmu_cap = 0;
>>> +    }
>>>   }
>>>     int kvm_arch_init_vcpu(CPUState *cs)
>>> @@ -2517,6 +2532,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>>>           }
>>>       }
>>>   +    has_pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
>>> +
>>>       ret = kvm_get_supported_msrs(s);
>>>       if (ret < 0) {
>>>           return ret;
>>
