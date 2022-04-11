Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1E944FBB31
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 13:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343930AbiDKLsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 07:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241472AbiDKLsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 07:48:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE1645AD0;
        Mon, 11 Apr 2022 04:45:55 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23B9r8mW025011;
        Mon, 11 Apr 2022 11:45:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=GorA4iF9Jt67PIAZN4SKEx4JggWyiVUz2ltv7KD+T1E=;
 b=a7ulmEihY8vBwWEBVsx7B4KxaEn4NydUo6xMBsGF5ee2IJDMlDytiGOcotXTRvAme7xf
 gPEU2ElvSRk4HmCzgU4a3O2CbR+KERNoy3Op5RRhw6In8XdnruV5CRJO0bhVeW8MUmLk
 8hgyjCKdeuQlLU6G96XMYz6KtTCYEcLTGb696Zn/EYldJJCi/5ZrR0ci8IuP294HTsMv
 9zeQ/ir73qqPBHzAfzvyGxt5Y8/3FRO8ZpE4kj91LErk+Ul1/VyGtZErjyDrmz9qbUmr
 B815zQO5q0BL2951uRPPNTOktK34tYK/xg5HcvLaOAShA85zLh4HCPwk8A2J9c3xC0g3 CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcf52ntv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 11:45:55 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23BBUpY7029843;
        Mon, 11 Apr 2022 11:45:55 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3fcf52ntua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 11:45:55 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23BBhrwl016839;
        Mon, 11 Apr 2022 11:45:52 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3fb1s8u10x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Apr 2022 11:45:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23BBjwlm44433808
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Apr 2022 11:45:58 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C97A42045;
        Mon, 11 Apr 2022 11:45:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FE1642042;
        Mon, 11 Apr 2022 11:45:49 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.68.171])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 Apr 2022 11:45:49 +0000 (GMT)
Message-ID: <662961c94c115be6f6285097b534c5b540be0258.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 2/9] s390x: css: Skip if we're not run
 by qemu
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, thuth@redhat.com, seiden@linux.ibm.com
Date:   Mon, 11 Apr 2022 13:45:49 +0200
In-Reply-To: <20220407084421.2811-3-frankja@linux.ibm.com>
References: <20220407084421.2811-1-frankja@linux.ibm.com>
         <20220407084421.2811-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _Lpcg1FikxI9NoyNu0ZY7LFkjN1bkQZZ
X-Proofpoint-GUID: Y100ZoORtT9afJHEFbA7YIB-bbhJO9bp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-11_03,2022-04-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxlogscore=949
 bulkscore=0 clxscore=1015 phishscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204110065
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-07 at 08:44 +0000, Janosch Frank wrote:
> There's no guarantee that we even find a device at the address we're
> testing for if we're not running under QEMU.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
