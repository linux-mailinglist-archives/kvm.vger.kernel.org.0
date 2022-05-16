Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F32527FF3
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 10:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242039AbiEPIn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 04:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241941AbiEPImn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 04:42:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2C9E0E9;
        Mon, 16 May 2022 01:42:41 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24G80vB0003985;
        Mon, 16 May 2022 08:42:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=ouF8ku5FjADVL/+LJWFJVWptV7w97rTQQu+CgY+kW3A=;
 b=UzVTLS7tyFE5AW4ZfyVPf+f4+1Hv0Gr4FlVjZBNwKjhD6eQ8Kgv2WugL7zqC6czFqwsH
 A38afKwrYpfRlq4ZFJbxBcws1VPyuIqhpsliOZHY7cnHav0wB/XXnJk7ZmhB6XXvCjA3
 l5pdQkC2/AohQ4FBfmbJj9xhcF8Dv7TW6juk7wZ017PWRhk4R8o4rKP8wEZQ3cae5dMn
 1MbRp2Ji6a4eW4yGUmbc9I3PEwtBY4N/r3Z0TJ3I5FFW1Xg2WVNwgZJ6o+vO9CxPv4kX
 3BbXUu3Y0GhrtRM0VJ7WYT+eMlplm+zc3EaTfyt0qTWAddcpN0L/+efkZU3AYBNjewYL 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3jqw0rht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:42:40 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24G8dCTm020110;
        Mon, 16 May 2022 08:42:40 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3jqw0rh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:42:40 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24G8gb9A024761;
        Mon, 16 May 2022 08:42:37 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 3g2428ste3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 08:42:37 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24G8g4qk33554924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 08:42:04 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E333A4054;
        Mon, 16 May 2022 08:42:34 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 42A7CA405B;
        Mon, 16 May 2022 08:42:34 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.50.122])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 08:42:34 +0000 (GMT)
Message-ID: <66bac51054fec66984d574eb34e319f370187ed6.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 4/6] s390x: uv-host: Add access exception
 test
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        scgl@linux.ibm.com
Date:   Mon, 16 May 2022 10:42:34 +0200
In-Reply-To: <20220513095017.16301-5-frankja@linux.ibm.com>
References: <20220513095017.16301-1-frankja@linux.ibm.com>
         <20220513095017.16301-5-frankja@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kAVEcGwWHRBm4AiDASpmxgE8KXe-xzqb
X-Proofpoint-ORIG-GUID: OXNcmB_pajkeuLymeifdUjCL2XnTWQsM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_03,2022-05-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 impostorscore=0 phishscore=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 mlxlogscore=984 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-05-13 at 09:50 +0000, Janosch Frank wrote:
> Let's check that we get access exceptions if the UVCB is on an
> invalid
> page or starts at a valid page and crosses into an invalid one.
>=20
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

