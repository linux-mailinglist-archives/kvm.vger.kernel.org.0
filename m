Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D8F6C685B
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 13:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbjCWMcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 08:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjCWMb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 08:31:58 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078631B304
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 05:31:58 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32NAje4Q007776
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 12:31:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=K4xj6x9c6iYG5rz9w/j1WhDayf+DnyBcqmwtGjces04=;
 b=aO/9Cbygm0QjLyR3vjVNvrka9HCgYpV3ZkFZ957BwjpgYeDIJn8j1rierP55XV0k7YqY
 0Y6kqaHYOTmmnDS/ERNIznyxJcp8pCnjm/Gkh5KOOWjteLiiaZjBXxHb6cqipSSdxmDH
 GsBRYI80feZMrxoYigNEFQXhke7B0VybD+J8zC0sMa3yqH5armXDLKSfNgf26AkXopbP
 XHKoS13sq2knx/yYzp0RhQ1ttM0Imff5fwszmj/KgThzeyhD6r843+oEKCeR09YHguP6
 K5C+dKtsnhYUiVQIfLuUHFT5nVqxjMkAEj19dcRCG4e/YolkqY0sEud8D+AAdeh1zEBc JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgk22dvq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 12:31:57 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NCPwkn022866
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 12:31:57 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgk22dvpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 12:31:57 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32MNNls5016112;
        Thu, 23 Mar 2023 12:31:54 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3pd4x6e5m0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 12:31:54 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NCVoIv31457874
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 12:31:50 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC9892004D;
        Thu, 23 Mar 2023 12:31:50 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9F792004B;
        Thu, 23 Mar 2023 12:31:50 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.6.128])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 12:31:50 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230323103913.40720-3-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com> <20230323103913.40720-3-frankja@linux.ibm.com>
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 2/8] s390x: uv-host: Check for sufficient amount of memory
Message-ID: <167957471038.13757.3158545609185537248@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 23 Mar 2023 13:31:50 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: esVukWh5cp3YYnwXmiKY4Osbzo1EBzh7
X-Proofpoint-GUID: cYkOj0_JyW6wFaUWt3AjpNGyM2ZBVAzw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230094
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-23 11:39:07)
> The UV init storage needs to be above 2G so we need a little over 2G
> of memory when running the test.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
