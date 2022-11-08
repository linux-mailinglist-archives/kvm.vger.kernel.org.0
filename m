Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BF2621842
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 16:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbiKHP3r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 10:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbiKHP3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 10:29:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766BADF3E;
        Tue,  8 Nov 2022 07:29:45 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A8F0UPh032218;
        Tue, 8 Nov 2022 15:29:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=6ClYdcSTIM15x9yP/n9hVlB2UNijn3w1qHATSH8B0zw=;
 b=NnSpkrNwKn/xXA4d5KSERQ6vpmgjTvLF8mY6EZRixoi+eN3mlatAko4bkFcPVCmSUMkM
 RKVNDzWvo3lauWZH09wZ6HoszDBdwPtCCOqS+gKp+j7eI9n/YwZiKVz91jZQ1rQdACSr
 Xwfj4H0/ySEhV9nwDGvgPiUhrjebL9KrgXsOI8y6EI3EkMZnNZsYvChOpvcZ1sxbHNB7
 mAMERfm3YxpfGdAiru0xopfeGiPlgzEi+VJEE0rNMbsl9vW1AhQA1lxm9r8yEByatEhr
 lHxGcQyNWT/2Zpk5VTglrDBIhp3+8+07AShoVhV1cKPI7UuBCQlC+GZjGJA+PVsPG560 UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqn18sjak-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 15:29:40 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2A8EviQ9027182;
        Tue, 8 Nov 2022 15:29:39 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqn18sj9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 15:29:39 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A8FL3a7012817;
        Tue, 8 Nov 2022 15:29:38 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 3kngmt56m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 15:29:38 +0000
Received: from smtpav02.wdc07v.mail.ibm.com ([9.208.128.114])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A8FTaV224969686
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Nov 2022 15:29:36 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 281C058060;
        Tue,  8 Nov 2022 15:29:36 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 848915805F;
        Tue,  8 Nov 2022 15:29:34 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.65.225.56])
        by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  8 Nov 2022 15:29:34 +0000 (GMT)
Message-ID: <ce7bfc8b7efccf0fc35f89d3c79992dfba511b3a.camel@linux.ibm.com>
Subject: Re: S390 testing for IOMMUFD
From:   Eric Farman <farman@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Date:   Tue, 08 Nov 2022 10:29:33 -0500
In-Reply-To: <Y2ppq9oeKZzk5F6h@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
         <Y2msLjrbvG5XPeNm@nvidia.com>
         <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
         <Y2pffsdWwnfjrTbv@nvidia.com>
         <67dafaf27cc029ffde1f7c474c2fd17907958d5a.camel@linux.ibm.com>
         <Y2ppq9oeKZzk5F6h@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P_SKBDwvlZfiinBD0eBx_aLkkupJRMzl
X-Proofpoint-ORIG-GUID: Bzn3ZN4qSDk6Vq4bcboMp4kUQqxBORC-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 mlxlogscore=999 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211080092
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

T24gVHVlLCAyMDIyLTExLTA4IGF0IDEwOjM3IC0wNDAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
Cj4gT24gVHVlLCBOb3YgMDgsIDIwMjIgYXQgMDk6MTk6MTdBTSAtMDUwMCwgRXJpYyBGYXJtYW4g
d3JvdGU6Cj4gPiBPbiBUdWUsIDIwMjItMTEtMDggYXQgMDk6NTQgLTA0MDAsIEphc29uIEd1bnRo
b3JwZSB3cm90ZToKPiA+ID4gT24gVHVlLCBOb3YgMDgsIDIwMjIgYXQgMDg6NTA6NTNBTSAtMDUw
MCwgTWF0dGhldyBSb3NhdG8gd3JvdGU6Cj4gPiA+IAo+ID4gPiA+IEZXSVcsIHZmaW8tcGNpIHZp
YSBzMzkwIGlzIHdvcmtpbmcgZmluZSBzbyBmYXIsIHRob3VnaCBJJ2xsIHB1dAo+ID4gPiA+IGl0
Cj4gPiA+ID4gdGhyb3VnaCBtb3JlIHBhY2VzIG92ZXIgdGhlIG5leHQgZmV3IHdlZWtzIGFuZCBy
ZXBvcnQgaWYgSSBmaW5kCj4gPiA+ID4gYW55dGhpbmcuCj4gPiA+IAo+ID4gPiBPSyBncmVhdAo+
ID4gPiAKPiA+ID4gPiBBcyBmYXIgYXMgbWRldiBkcml2ZXJzLi4uwqAgCj4gPiA+ID4gCj4gPiA+
ID4gLWNjdzogU291bmRzIGxpa2UgRXJpYyBpcyBhbHJlYWR5IGF3YXJlIHRoZXJlIGlzIGFuIGlz
c3VlIGFuZAo+ID4gPiA+IGlzCj4gPiA+ID4gaW52ZXN0aWdhdGluZyAoSSBzZWUgZXJyb3JzIGFz
IHdlbGwpLgo+ID4gCj4gPiBJIC10aGluay0gdGhlIHByb2JsZW0gZm9yIC1jY3cgaXMgdGhhdCB0
aGUgbmV3IHZmaW9fcGluX3BhZ2VzCj4gPiByZXF1aXJlcwo+ID4gdGhlIGlucHV0IGFkZHJlc3Nl
cyB0byBiZSBwYWdlLWFsaWduZWQsIGFuZCB3aGlsZSBtb3N0IG9mIG91cnMgYXJlLAo+ID4gdGhl
Cj4gPiBmaXJzdCBvbmUgaW4gYW55IGdpdmVuIHRyYW5zYWN0aW9uIG1heSBub3QgYmUuIFdlIG5l
dmVyIGJvdGhlcmVkIHRvCj4gPiBtYXNrIG9mZiB0aGUgYWRkcmVzc2VzIHNpbmNlIGl0IHdhcyBo
YW5kbGVkIGZvciB1cywgYW5kIHdlIG5lZWRlZAo+ID4gdG8KPiA+IGtlZXAgdGhlIG9mZnNldHMg
YW55d2F5Lgo+ID4gCj4gPiBCeSBoYXBwZW5zdGFuY2UsIEkgaGFkIHNvbWUgY29kZSB0aGF0IHdv
dWxkIGRvIHRoZSBtYXNraW5nCj4gPiBvdXJzZWx2ZXMKPiA+IChmb3IgYW4gdW5yZWxhdGVkIHJl
YXNvbik7IEknbGwgc2VlIGlmIEkgY2FuIGdldCB0aGF0IGZpdCBvbiB0b3AKPiA+IGFuZCBpZgo+
ID4gaXQgaGVscHMgbWF0dGVycy4gQWZ0ZXIgY29mZmVlLgo+IAo+IE9oLCB5ZXMsIHRoYXQgbWFr
ZXMgYWxvdCBvZiBzZW5zZS4KPiAKPiBBaCwgaWYgdGhhdCBpcyBob3cgVkZJTyB3b3JrZWQgd2Ug
Y291bGQgbWF0Y2ggaXQgbGlrZSBiZWxvdzoKClRoYXQncyBhIHN0YXJ0LiBUaGUgcGluIGFwcGVh
cnMgdG8gaGF2ZSB3b3JrZWQsIGJ1dCB0aGUgdW5waW4gZmFpbHMgYXQKdGhlIGJvdHRvbSBvZiBp
b21tdWZkX2FjY2Vzc191bnBpbl9wYWdlczoKCldBUk5fT04oIWlvcHRfYXJlYV9jb250aWdfZG9u
ZSgmaXRlcikpOwoKPiAKPiDCoEVYUE9SVF9TWU1CT0xfTlNfR1BMKGlvbW11ZmRfYWNjZXNzX3Vu
cGluX3BhZ2VzLCBJT01NVUZEKTsKPiDCoAo+IMKgc3RhdGljIGJvb2wgaW9wdF9hcmVhX2NvbnRp
Z19pc19hbGlnbmVkKHN0cnVjdCBpb3B0X2FyZWFfY29udGlnX2l0ZXIKPiAqaXRlciwKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCBib29sIGZpcnN0KQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wg
Zmlyc3QsIHVuc2lnbmVkIGxvbmcKPiBmaXJzdF9pb3ZhKQo+IMKgewo+IC3CoMKgwqDCoMKgwqAg
aWYgKGlvcHRfYXJlYV9zdGFydF9ieXRlKGl0ZXItPmFyZWEsIGl0ZXItPmN1cl9pb3ZhKSAlCj4g
UEFHRV9TSVpFKQo+ICvCoMKgwqDCoMKgwqAgdW5zaWduZWQgbG9uZyBzdGFydF9vZmZzZXQgPSBm
aXJzdCA/IChmaXJzdF9pb3ZhICUgUEFHRV9TSVpFKQo+IDogMDsKPiArCj4gK8KgwqDCoMKgwqDC
oCBpZiAoKGlvcHRfYXJlYV9zdGFydF9ieXRlKGl0ZXItPmFyZWEsIGl0ZXItPmN1cl9pb3ZhKSAl
Cj4gUEFHRV9TSVpFKSAhPQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdGFydF9vZmZzZXQpCj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiBmYWxzZTsKPiDCoAo+IMKgwqDC
oMKgwqDCoMKgIGlmICghaW9wdF9hcmVhX2NvbnRpZ19kb25lKGl0ZXIpICYmCj4gQEAgLTYwNyw3
ICs2MTAsNyBAQCBpbnQgaW9tbXVmZF9hY2Nlc3NfcGluX3BhZ2VzKHN0cnVjdAo+IGlvbW11ZmRf
YWNjZXNzICphY2Nlc3MsIHVuc2lnbmVkIGxvbmcgaW92YSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlvcHRfYXJlYV9pb3ZhX3RvX2luZGV4KGFyZWEs
IGl0ZXIuY3VyX2lvdmEpOwo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlm
IChhcmVhLT5wcmV2ZW50X2FjY2VzcyB8fAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgIWlvcHRfYXJlYV9jb250aWdfaXNfYWxpZ25lZCgmaXRlciwgZmlyc3QpKSB7Cj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAhaW9wdF9hcmVhX2NvbnRpZ19p
c19hbGlnbmVkKCZpdGVyLCBmaXJzdCwgaW92YSkpCj4gewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmMgPSAtRUlOVkFMOwo+IMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBlcnJfcmVtb3ZlOwo+IMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4gCj4gSmFzb24KCg==

